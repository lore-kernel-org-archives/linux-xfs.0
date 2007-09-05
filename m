Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Sep 2007 18:19:53 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l851Jn4p015559
	for <xfs@oss.sgi.com>; Tue, 4 Sep 2007 18:19:50 -0700
Message-ID: <46DE042D.8060103@sgi.com>
Date: Wed, 05 Sep 2007 11:19:41 +1000
From: Timothy Shimmin <tes@sgi.com>
MIME-Version: 1.0
Subject: Re: [PATCH] log replay should not overwrite newer ondisk inodes
References: <46D6279F.40601@sgi.com> <46DDE4A2.1070204@agami.com>
In-Reply-To: <46DDE4A2.1070204@agami.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Shailendra Tripathi <stripathi@agami.com>
Cc: Lachlan McIlroy <lachlan@sgi.com>, xfs-dev <xfs-dev@sgi.com>, xfs-oss <xfs@oss.sgi.com>

Shailendra Tripathi wrote:
> Hi,
>      Can someone explain how not checking the flushiter can losse 
> filesize updates.
> Let me the take the case mentioned here in the fix statement:
> 
> a. Clustered inode create -  flush iter - X( 0)
> b. size update  --> flush iter --> Y
> 
> X and Y will always hold as: X <= Y, that is, it is not possible to have 
> X >Y (unless size update is non -transactional. As far as I know, size 
> update is always transactional.)
> 
> There are 2 cases here:
> a) log of Y reached to the disk  --> 1) inode with flush iter was 
> reached 2) inode didn't make.
> b) log of Y didn't reach the disk --> flush_iter Y should have never 
> reached disk
> 
> In none of cases, I can see the possibility that size update can be lost 
> becuase of replaying of the logs in the sequential order. If Log of Y 
> didn't reach, does it not make sense to have the flush_iter and size 
> correctly set to the last known transaction on the disk. To me, it 
> appears unsafe to do as the inode state will not match the state of the 
> last known transaction after recovery.
> 
> Regards,
> Shailendra

Dave answered this but yes this is a case where we are breaking
the transaction model IMO. And my understanding is that we are doing
this for performance reasons.
One of Lachlan's proposals (IIRC) was to log the size change before the
ondisk size change in xfs_aops.c/xfs_setfilesize()
and thus follow the model but questions were raised about introducing
performance overhead of log traffic in the write path.

--Tim
