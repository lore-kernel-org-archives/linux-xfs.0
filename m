Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n6IGTg7s161816 for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 11:29:43 -0500
Received: from mx2.redhat.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id B552A12A52FD
	for <xfs@oss.sgi.com>; Sat, 18 Jul 2009 09:38:14 -0700 (PDT)
Received: from mx2.redhat.com (mx2.redhat.com [66.187.237.31]) by cuda.sgi.com
	with ESMTP id B8biHShyCDu0tQcP for <xfs@oss.sgi.com>;
	Sat, 18 Jul 2009 09:38:14 -0700 (PDT)
Message-ID: <4A61F895.9090704@redhat.com>
Date: Sat, 18 Jul 2009 11:30:13 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: very basic defragmentation testing for xfs
	&	ext4
References: <4A5E3A37.5050306@redhat.com>
	<20090718143114.GC20905@infradead.org>
In-Reply-To: <20090718143114.GC20905@infradead.org>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: ext4 development <linux-ext4@vger.kernel.org>, xfs mailing list <xfs@oss.sgi.com>

Christoph Hellwig wrote:
> On Wed, Jul 15, 2009 at 03:21:11PM -0500, Eric Sandeen wrote:

...

>> (md5sums may just be reading buffered data though,
>> suggestions?)
> 
> As Andreas said unmount it before.
> 
>> The test currently expects to find e4defrag in
>> /usr/bin
> 
>> +_supported_fs xfs ext4
> 
>> +fragfile=$SCRATCH_MNT/fragfile.$$
>> +
>> +if [ "$FSTYP" == "xfs" ]; then
>> +	DEFRAG=/usr/sbin/xfs_fsr
>> +else
>> +	DEFRAG=/usr/bin/e4defrag
>> +fi
>> +
>> +_require_command $DEFRAG
>> +_require_command /usr/sbin/filefrag
> 
> I think we're much better off adding a helpers for this in a new
> common.defrag (or adding it somwhere).
> 
> Then set a DEFRAF_PROG variable there, and add a _require_defrag
> ala


Both ideas sound good, will send a V2.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
