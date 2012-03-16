Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2GHFBFe109931 for <xfs@oss.sgi.com>; Fri, 16 Mar 2012 12:15:11 -0500
Received: from smtp.pobox.com (b-pb-sasl-quonix.pobox.com [208.72.237.35]) by
	cuda.sgi.com with ESMTP id gCpPgmxij5Y3yUqD for
	<xfs@oss.sgi.com>; Fri, 16 Mar 2012 10:15:09 -0700 (PDT)
Date: Fri, 16 Mar 2012 17:15:09 +0000
From: Brian Candler <B.Candler@pobox.com>
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Message-ID: <20120316171509.GD49365@nsrc.org>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<20321.63389.586851.689070@tree.ty.sabi.co.UK>
	<CAA8mOyCUCyzGCuNtn4txFuBtbk22M6LRpShNVH_Szb5=_F1PBw@mail.gmail.com>
	<20322.29849.917554.794740@tree.ty.sabi.co.UK>
	<CAA8mOyC-xCcNxQFz-M1_TfnxcGBmpUdQ57_vYNVF11jhWK3SSA@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAA8mOyC-xCcNxQFz-M1_TfnxcGBmpUdQ57_vYNVF11jhWK3SSA@mail.gmail.com>
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
To: Jessie Evangelista <jessie.evangelista@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>, Peter Grandi <pg@lxra2.for.sabi.co.uk>, Linux fs XFS <xfs@oss.sgi.com>

On Fri, Mar 16, 2012 at 11:36:07AM +0800, Jessie Evangelista wrote:
> I'm still scouring the internet for a best practice recipe for
> implementing xfs/mdraid.
> I am open to writing one and including the inputs everyone is contributing here.
> In my search, I also saw some references of alignment issues for partitions.
> this is what I used to setup the partitions for the md device
> 
> sfdisk /dev/sdb <<EOF
> unit: sectors
> 
> 63,104872257,fd
> 0,0,0
> 0,0,0
> 0,0,0
> EOF
> 
> I've read a recommendation to start the partition on the 1MB mark.
> Does this make sense?

I would just make the raw disks members of the RAID array, e.g.
/dev/sdb, /dev/sdc etc and not partition them.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
