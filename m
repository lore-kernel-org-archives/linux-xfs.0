Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q3D7J8c8005618 for <xfs@oss.sgi.com>; Fri, 13 Apr 2012 02:19:08 -0500
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id Cz6GH2fXDGF0p7jQ for
	<xfs@oss.sgi.com>; Fri, 13 Apr 2012 00:19:06 -0700 (PDT)
Date: Fri, 13 Apr 2012 08:19:05 +0100
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Fragmentation Issue We Are Having
Message-ID: <20120413071905.GA823@nsrc.org>
References: <CADrkzimg891ZBGK7-UzhGeey16KwH-ZXpEqFr=O3KwD3qA9LwQ@mail.gmail.com>
	<20120412075747.GB30891@nsrc.org>
	<CADrkzi=JNsbXJHkcb=oOZHLEYMBDUkNHu9O8JFT9h+kSArL47A@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CADrkzi=JNsbXJHkcb=oOZHLEYMBDUkNHu9O8JFT9h+kSArL47A@mail.gmail.com>
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
To: David Fuller <dfuller@epoch.com>
Cc: xfs@oss.sgi.com

On Thu, Apr 12, 2012 at 05:09:40PM -0700, David Fuller wrote:
>    The total LVM volume group is 4.5 TB.  The logical volume is around
>    2.3TB where the mysql data

Hence you have a 2.3TB XFS filesystem? You need inode64. The side warning
"performance sucks" is very true.  In particular, if you create a bunch of
files in the same directory, without inode64 XFS will scatter the extents
all over the disk rather than trying to allocate them next to each other
(possibly not a problem if you're only storing mysql data chunks though)

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
