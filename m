Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Mon, 06 Oct 2008 18:21:31 -0700 (PDT)
Received: from relay.sgi.com (relay2.corp.sgi.com [192.26.58.22])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m971LSQT013191
	for <xfs@oss.sgi.com>; Mon, 6 Oct 2008 18:21:28 -0700
Message-ID: <48EAB9F6.4090102@sgi.com>
Date: Tue, 07 Oct 2008 12:23:02 +1100
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: Adding attr, inode reference query
References: <op.uimntunh3jf8g2@pc-bnaujok.melbourne.sgi.com> <20081007005409.GD12509@disturbed>
In-Reply-To: <20081007005409.GD12509@disturbed>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Dave Chinner <david@fromorbit.com>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Dave Chinner wrote:
> On Tue, Oct 07, 2008 at 11:04:32AM +1100, Barry Naujok wrote:
>> I'm doing a bit of debugging with attr creation in xfs_repair which uses
>> libxfs which has it's own simple cache/ref counting/transaction mechanism
>> for inodes and buffers.
>>
>> I came across a refcounting issue when adding an extended attribute to an
>> inode, calling xfs_attr_set_int (indirectly in Phase 6):
>>   - if there are no extended attributes, a attr fork area is created within
>>     the inode (calling xfs_bmap_add_attrfork). After this call in libxfs,
>>     the inode is derefenced.
>>   - if extended attributes already exist, the inode isn't dereferenced
>>     after calling xfs_attr_set_int.
>>
>> I seem to have traced this down to xfs_bmap_add_attrfork not calling
>> xfs_trans_ihold after calling xfs_trans_ijoin like other similar functions.
>> BUT, it does call IHOLD(ip).
> 
> The difference between the two is kinda subtle. IHOLD() increments
> the reference count to ensure the transaction commit doesn't drop
> the last reference to the inode when it unlocks it and hence
> cause us to enter reclaim in the commit code.
> 
> OTOH, xfs_trans_ihold() holds the inode across the transaction
> commit so that it is still locked when xfs_trans_commit() completes.
> This is needed for rolling transactions to be able to continue
> across duplication and commit without needing to relock inodes.
> 
Oh okay.
Want a reference held in both cases, but don't always want it locked
after commit.
One way, we take an extra reference and then drop it at commit,
the other we just don't drop the reference at commit.

--Tim
