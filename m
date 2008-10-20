Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 19 Oct 2008 20:37:09 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m9K3axkq004502
	for <xfs@oss.sgi.com>; Sun, 19 Oct 2008 20:36:59 -0700
Message-ID: <48FC0B16.9090102@sgi.com>
Date: Mon, 20 Oct 2008 14:37:42 +1000
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: [PATCH] Re: another problem with latest code drops
References: <20081016060247.GF25906@disturbed> <48F6EF7F.4070008@sgi.com> <20081016072019.GH25906@disturbed> <48F6FCB7.6050905@sgi.com> <20081016222904.GA31761@disturbed> <48F7E7BA.4070209@sgi.com> <20081017012141.GJ25906@disturbed> <20081017020434.GD31761@disturbed> <20081017020718.GE31761@disturbed> <48FBEED9.30609@sgi.com> <20081020031757.GM31761@disturbed>
In-Reply-To: <20081020031757.GM31761@disturbed>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Lachlan McIlroy <lachlan@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Dave Chinner wrote:
> On Mon, Oct 20, 2008 at 12:37:13PM +1000, Lachlan McIlroy wrote:
>> Dave Chinner wrote:
>>> On Fri, Oct 17, 2008 at 01:04:34PM +1100, Dave Chinner wrote:
>>>> On Fri, Oct 17, 2008 at 12:21:41PM +1100, Dave Chinner wrote:
>>>>> On Fri, Oct 17, 2008 at 11:17:46AM +1000, Lachlan McIlroy wrote:
>>>>>> Dave Chinner wrote:
>>>>>>>> I am seeing a lot of memory used here though:
>>>>>>>>
>>>>>>>> 116605669 116605669  26%    0.23K 6859157       17  27436628K selinux_inode_security
>>>>>>> Ah - I don't run selinux. Sounds like a bug that needs reporting
>>>>>>> to lkml...
>>>>>> I'm sure this is caused by your changes that introduced inode_init_always().
>>>>>> It re-initialises an existing inode without destroying it first so it calls
>>>>>> security_inode_alloc() without calling security_inode_free().
>>>>> I can't think of how. The layers above XFS are symmetric:
>>>> .....
>>>>> And we should have this symmetry everywhere.
>>>>>
>>>>> <thinks for a bit>
>>>>>
>>>>> Hmmmm - maybe the xfs_iget_cache_miss failure paths where we call
>>>>> xfs_idestroy() could leak contexts. We should really call xfs_iput()
>>>>> because we have an initialised linux inode at this point and so
>>>>> we need to go through destroy_inode(). I'll have a bit more of
>>>>> a look, but this doesn't seem to account for the huge number of
>>>>> leaked contexts you reported....
>>>> Patch below that replaces xfs_idestroy() with IRELE() to destroy
>>>> the inode via the normal iput() path. It also fixes a second issue
>>>> that I found by inspection related to security contexts as a result
>>>> of hooking up ->destroy_inode.
>>>>
>>>> It's running QA now.
>>>>
>>>> FWIW, I'm not sure if this patch will apply cleanly - I'm still
>>>> running of my stack of patches and not what has been checked into
>>>> ptools. Any idea of when all the patches in ptools will be pushed
>>>> out to the git tree?
>>> And now with the patch.
>> Nope, that didn't help.  The system still leaks - and at the same
>> apparent rate too.
> 
> I didn't fix xfs_iread() properly - it still calls xfs_idestroy()
> directly rather than dropping reference counts. Updated patch below
> that should fix this.
> 
>> I also hit this panic where we have taken a reference on an inode
>> that has I_CLEAR set.  I suspect we've made it into xfs_iget_cache_hit()
> 
> I don't think there is an iput() in that path.  The only iput() call
> should be the IRELE() I added to xfs_iget_cache_miss(). Can you make
> sure the compiler is not inlining functions so we can pin-point
> where the iput() call is coming from? (i.e. static > STATIC on the
> hit/miss functions)
Just disassembled xfs_iget() and xfs_iget_cache_miss() has been inlined
and we're calling the IRELE() at the end of that function.

> 
>> and found an inode with XFS_IRECLAIMABLE set and since we don't call
>> igrab() we don't do the I_CLEAR check.
> 
> In that case, we call inode_init_always() instead which sets the
> state to I_NEW and the reference count to 1. In the error case,
> the inode will have already been freed and we make
We don't set inode->i_state to i_NEW.  We're stuffing XFS_INEW into
the XFS inode's i_flags field and not removing the I_CLEAR from the
linux inode.  Note that inode_init_always() doesn't touch i_state.

> 
>> I'm not really convinced that
>> activating dead inodes is such a good idea.
> 
> By the time the XFS_IRECLAIMABLE flag is set, I_CLEAR has been set
> on the VFS inode. It is safe to re-use the inode at this point as
> the VFS inode has been "destroyed" and hence all we need to do is
> re-initialise it. We've always done this for inodes in reclaim so
> we don't have to re-read them off disk...
> 
> Cheers,
> 
> Dave.
