Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n89GmUIQ170263 for <xfs@OSS.SGI.com>; Wed, 9 Sep 2009 11:48:50 -0500
Received: from ty.sabi.co.UK (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 131EB43A7A2
	for <xfs@OSS.SGI.com>; Wed,  9 Sep 2009 09:49:05 -0700 (PDT)
Received: from ty.sabi.co.UK (82-69-39-138.dsl.in-addr.zen.co.uk
	[82.69.39.138]) by cuda.sgi.com with ESMTP id c6BF07CbZNZvBpHv
	for <xfs@OSS.SGI.com>; Wed, 09 Sep 2009 09:49:05 -0700 (PDT)
Received: from from [127.0.0.1] (helo=tree.ty.sabi.co.uk)
	by ty.sabi.co.UK with esmtp(Exim 4.63 #1) id 1MlQLf-0005Vj-DP
	for <xfs@OSS.SGI.com>; Wed, 09 Sep 2009 16:48:47 +0000
Resent-Message-ID: <19111.56429.547491.349942@tree.ty.sabi.co.uk>
Resent-To: xfs@oss.sgi.com
Subject: Re: xfs data loss
Date: Sun, 6 Sep 2009 20:30:38 +0000
MIME-Version: 1.0
From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
Message-ID: <19108.7150.743356.919855@tree.ty.sabi.co.uk>
References: <B9A7B002C7FAFC469D4229539E909760308DA658CB@DU-EXC-MAIL.empa.emp-eaw.ch>
	<19106.44559.288658.248853@tree.ty.sabi.co.uk>
	<4AA3261E.1000005@sandeen.net>
In-Reply-To: <4AA3261E.1000005@sandeen.net>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
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
To: Linux XFS <xfs@oss.sgi.com>


>> There is one vital detail here: the XFS design in effect makes
>> two assumptions:
>> 
>> * The block layer is error free. By and large XFS does not even
>> check that the block layer behaves perfectly. It is the sysadm
>> responsibility to ensure that.

> Now, that's not quite accurate.  XFS is -very- good at handling
> IO errors in general, and at detecting & handling metadata
> corruption

But what about recovering from bad blocks? For example bad blocks
that happen in the middle of a chunk of metadata? IIRC one cannot
even pass a list of bad blocks to 'mkfs.xfs' (JFS can handle that
statically, 'ext3' semi-dynamically). If one is lucky XFS will
have in some cases enough redundancy in the metadata to allow a
repair, but it does not seem to me that this has been a design
goal, just happenstance and lots of work in 'xfs_repair'.

> (potentially coming up from bad hardware) at runtime.... (where
> "handling" may mean "detecting and shutting down gracefully")

Without data loss? Because that is what matter to quit a few
people. Handling data loss by acknowledging it is a bit of an
optimistic usage of "handling", even if ignoring errors is even
worse. My impression is that XFS assumes that the block layer
handles all data loss (and maybe corruption) issues.

> XFS -does- expect that when the hardware says an IO is complete,
> it is complete and safe on disk.

As to this, actually this is one of the few areas where XFS
actually is to be praised as it does try to check whether the
block layer claims to do that.

> If that's what you refer to then we're in agreement.

I was not saying that XFS ignores errors; I am referring to making
the file system detects and works around block layer failures
without data loss or at least usability loss.

Some file systems add metadata to each block or extent to
facilitate data reconstruction in the case of bad blocks arising,
whether detected by the block layer or even without, some add it
to facilitate metadata index reconstruction (e.g. accidentally
VFAT, by design Reiser).

Personally I think that designing XFS to put all data loss issues
to the block device layer was the right decision given its likely
goals. I am more of a believer in end-to-end reliability checks
and/or block layer redundancy.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
