Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 26 Aug 2007 23:46:52 -0700 (PDT)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id l7R6kj4p024714
	for <linux-xfs@oss.sgi.com>; Sun, 26 Aug 2007 23:46:48 -0700
Message-ID: <46D26D96.7050209@sgi.com>
Date: Mon, 27 Aug 2007 16:22:14 +1000
From: Mark Goodwin <markgw@sgi.com>
Reply-To: markgw@sgi.com
MIME-Version: 1.0
Subject: Re: TAKE 969192: Default mount option "noikeep" makes the inode generation
 number non-persistent
References: <46CE581A.2000405@sgi.com> <20070824113631.GA26868@infradead.org> <20070824124933.GS61154114@sgi.com>
In-Reply-To: <20070824124933.GS61154114@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: David Chinner <dgc@sgi.com>
Cc: Christoph Hellwig <hch@infradead.org>, Vlad Apostolov <vapo@sgi.com>, linux-xfs@oss.sgi.com



David Chinner wrote:
> On Fri, Aug 24, 2007 at 12:36:31PM +0100, Christoph Hellwig wrote:
>> On Fri, Aug 24, 2007 at 02:01:30PM +1000, Vlad Apostolov wrote:
>>> To avoid the problem with identical DMAPI handles, the XFSMNT_IDELETE mount
>>> option should be set as default, only if the filesystem is not mounted with
>>> XFSMNT_DMAPI.
>> Note that we have the same problem with nfs exports aswell.  Dateo maybe we
>> need a real fix insteead and keep a block of generation numbers around even
>> if and inode cluster is freed or something similar.
> 
> Yes. NFS is less critical than dmapi, though - with NFS filehandles just a
> change in generation number is usually good enough to catch most stale
> filehandle issues. With DMAPI, there's applications that record inode
> number/generation pairs and expect them never to repeat ever again.
> 
> We haven't had any reports of probelms with NFS servers due to this,
> but as soon as our HSm was exposed to this code we started getting
> strange coherency and corruption problems that have taken some time
> to track down to this issue. Hence this change seems like the
> best tradeoff while we work out a real solution.
> 
> At this point I suspect a deleted inode cluster btree in the AGI
> is the best solution because it can share most of the btree
> code with the current AGI btree and keeps the granularity of
> shared generation numbers quite fine.

Having a persistent highest/shared generation number per inode cluster
only solves part of the problem - with only 32 bits of precision, eventually
it will wrap. Generation numbers need more precision to solve this
completely. With more precision, the starting value could simply be
based on a timestamp ...

-- 

  Mark Goodwin                                  markgw@sgi.com
  Engineering Manager for XFS and PCP    Phone: +61-3-99631937
  SGI Australian Software Group           Cell: +61-4-18969583
-------------------------------------------------------------
