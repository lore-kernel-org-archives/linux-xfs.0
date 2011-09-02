Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p828niX6063198 for <xfs@oss.sgi.com>; Fri, 2 Sep 2011 03:49:44 -0500
Received: from bombadil.infradead.org (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 8D4D813BA779
	for <xfs@oss.sgi.com>; Fri,  2 Sep 2011 01:53:19 -0700 (PDT)
Received: from bombadil.infradead.org
	(173-166-109-252-newengland.hfc.comcastbusiness.net
	[173.166.109.252]) by cuda.sgi.com with ESMTP id
	IMWV2EAnQWftR4wt for <xfs@oss.sgi.com>;
	Fri, 02 Sep 2011 01:53:19 -0700 (PDT)
Date: Fri, 2 Sep 2011 04:49:41 -0400
From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] Added test case 259 for the btrfs raid features
Message-ID: <20110902084941.GB29054@infradead.org>
References: <4E3BA2F7.4080500@oracle.com>
 <4E44351D.4020202@oracle.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <4E44351D.4020202@oracle.com>
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
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

On Fri, Aug 12, 2011 at 04:01:33AM +0800, Anand Jain wrote:
> Added test case 259 for the btrfs raid features. SCRATCH_DEV_POOL must
> be set to 2 or more disks.

Any chance you can document how SCRATCH_DEV_POOL is supposed to be
used in the README file?  An addition patch is fine, no need to update
the existing ones.    Also is there a chance you could allow setting
only SCRATCH_DEV_POOL for btrfs, and derive SCRATCH_DEV for that as an
additional step?

> +# arg 1 remove/add
> +# arg 2 /dev/sdx or return of devmgt resply
> +_devmgt()
> +{
> +	local x
> +	local d
> +
> +	if [ $1 == "remove" ]; then
> +		d=`echo $2|cut -d"/" -f3`
> +		x=`ls -l /sys/class/block/${d} | cut -d "/" -f12 | sed 's/:/ /g'`
> +		echo "scsi remove-single-device ${x}" > /proc/scsi/scsi || _fail
> "Remove disk failed"
> +		DEVHTL=${x}
> +	else
> +		echo "scsi add-single-device ${2}" > /proc/scsi/scsi || _fail
> "Add disk failed"
> +	fi
> +}

Please use the sysfs interface instead of the deprecated /proc/scsi/scsi
interface.  I would also suggest to split this routine into two for
removing and adding, and move them to the common helper library, so it
could be used for other tests.

> +# we need this to test removing a dev from the system
> +_require_proc_scsi()
> +{
> +	[ -e /proc/scsi/scsi ]  || _notrun "/proc/scsi/scsi is not present"
> +}

The _require need really is that the device you want to work on is a
SCSI device.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
