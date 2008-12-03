Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id
	mB33bdVm012269 for <xfs@oss.sgi.com>; Tue, 2 Dec 2008 21:37:40 -0600
From: Niv Sardi <xaiki@sgi.com>
Subject: Re: New XFS git tree on oss.sgi.com
References: <492BA7AD.5080007@sgi.com> <20081125081644.GA20644@infradead.org>
	<492C0B3D.3040002@thebarn.com> <492CA07F.1030803@sgi.com>
	<492CC201.3080304@xfs.org>
Date: Wed, 03 Dec 2008 14:37:27 +1100
In-Reply-To: <492CC201.3080304@xfs.org> (Russell Cattelan's message of "Tue,
	25 Nov 2008 21:26:57 -0600")
Message-ID: <ncc3ah6lyiw.fsf@itchy.melbourne.sgi.com>
MIME-Version: 1.0
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Russell Cattelan <cattelan@thebarn.com>
Cc: xfs@oss.sgi.com

Russell Cattelan <cattelan@thebarn.com> writes:

> Lachlan McIlroy wrote:
>
>> Russell Cattelan wrote:
>>> Christoph Hellwig wrote:
>>>> On Tue, Nov 25, 2008 at 06:22:21PM +1100, Lachlan McIlroy wrote:
>>>>  
>>>>> There's a few branches there already:
>>>>>
>>>>> 'master'      This will contain all the latest xfs changes not yet 
>>>>> pushed
>>>>>                to mainline.
>>>>> 'mainline'    This is vanilla mainline and will updated regularly.
>>>>> 'for-linus'   Our staging branch for pull requests
>>>>> 'xfs-dev'     This branch will contain KDB and other supporting 
>>>>> code for
>>>>>                development and should be identical to the old CVS 
>>>>> tree.
>>>>>
>>>>> Feel free to start using it and let us know if you have any issues.
>>>>>     
>>>>
>>>> Any chance to have these as separate git trees instead of branches?
>>>>
>>>> In either case, do you expect patches against the xfs-dev or the master
>>>> tree?  It would also be useful if the trees and which one to be used
>>>> could be documented on oss.sgi.com/projects/xfs or xfs.org.
>>>>
>>>>   
>>> Specifically this page please.
>>> http://xfs.org/index.php/Getting_the_latest_source_code> Sure.  I didn't even know that page existed.
>>
>>>
>>> Maybe add a quick tutorial on git branches and how to create tracking 
>>> branches for this tree.
>> Can we just point people at an existing git tutorial?  Or are you wanting
>> something specific to our processes?
> most git tutorials seem to be specific to one particular process so 
> maybe a link to
> a reasonable howto and then a few extra examples blurbs on how to create 
> and deal
> with tracking branches.
>
> Maybe how to create tracking clones for each branch if that is what 
> people want to do.
>
> Personally I like branches as they help keep the tree cluster down and I 
> don't have to think
> up naming schemes to help me remember what is what, but sounds like some 
> people may
> like having multiple clones.

Sorry, I've been droped out, the mailining list change confused my
procmail.

$ git clone git://oss.sgi.com/xfs/xfs.git

# checking out xfs-dev and making it track the repo:
$ git checkout -b xfs-dev --track origin/xfs-dev

# adding a remote
$ git remote add $name $remoteurl
$ git remote udpate

that will put your remote branches in the $name/$branch namespace.

Anything else ? 

>>> Also can we have something other than "unnamed repository" in the 
>>> description file?
>> Okay, how do we change that?
>>
>>>
>>>> _______________________________________________
>>>> xfs mailing list
>>>> xfs@oss.sgi.com
>>>> http://oss.sgi.com/mailman/listinfo/xfs>>>   
>>>
>>>
>>
>
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs

-- 
Niv Sardi

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
