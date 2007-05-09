Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 09 May 2007 10:07:34 -0700 (PDT)
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l49H7TfB023872
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 10:07:31 -0700
Received: from d03relay02.boulder.ibm.com (d03relay02.boulder.ibm.com [9.17.195.227])
	by e34.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id l49H7TOQ015642
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 13:07:29 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay02.boulder.ibm.com (8.13.8/8.13.8/NCO v8.3) with ESMTP id l49H7SWv169794
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 11:07:28 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l49H7RwY000330
	for <xfs@oss.sgi.com>; Wed, 9 May 2007 11:07:28 -0600
Subject: Re: [PATCH 1/5] fallocate() implementation in i86, x86_64 and
	powerpc
From: Mingming Cao <cmm@us.ibm.com>
Reply-To: cmm@us.ibm.com
In-Reply-To: <20070509160102.GA30745@amitarora.in.ibm.com>
References: <20070329115126.GB7374@amitarora.in.ibm.com>
	 <20070329101010.7a2b8783.akpm@linux-foundation.org>
	 <20070330071417.GI355@devserv.devel.redhat.com>
	 <20070417125514.GA7574@amitarora.in.ibm.com>
	 <20070418130600.GW5967@schatzie.adilger.int>
	 <20070420135146.GA21352@amitarora.in.ibm.com>
	 <20070420145918.GY355@devserv.devel.redhat.com>
	 <20070424121632.GA10136@amitarora.in.ibm.com>
	 <20070426175056.GA25321@amitarora.in.ibm.com>
	 <20070426180332.GA7209@amitarora.in.ibm.com>
	 <20070509160102.GA30745@amitarora.in.ibm.com>
Content-Type: text/plain
Date: Wed, 09 May 2007 10:07:25 -0700
Message-Id: <1178730446.3815.8.camel@dyn9047017103.beaverton.ibm.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Amit K. Arora" <aarora@linux.vnet.ibm.com>
Cc: torvalds@osdl.org, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org, xfs@oss.sgi.com, suparna@in.ibm.com

On Wed, 2007-05-09 at 21:31 +0530, Amit K. Arora wrote:
> I have the updated patches ready which take care of Andrew's comments.
> Will run some tests and post them soon.
> 
> But, before submitting these patches, I think it will be better to finalize
> on certain things which might be worth some discussion here:
> 
> 1) Should the file size change when preallocation is done beyond EOF ?
>    - Andreas and Chris Wedgwood are in favor of not changing the
>      file size in this case. I also tend to agree with them. Does anyone
>      has an argument in favor of changing the filesize ?
>      If not, I will remove the code which changes the filesize, before I
>      resubmit the concerned ext4 patch.
> 

If we chose not to update the file size beyong EOF, then for filesystem
without fallocate() support (ext2,3 currently), posix_fallocate() will
follow the hard way(zero-out) to do preallocation. Then we will get
different behavior on filesystems w/o fallocate() support. It make sense
to be consistent, IMO.

My point of view, preallocation is just a efficient way to allocating
blocks for files without zero-out, other than this, the new behavior
should be consistent with the old way: file size update,mtime/ctime,
ENOSPC etc.

Mingming
