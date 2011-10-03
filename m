Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p938uMbl229957 for <xfs@oss.sgi.com>; Mon, 3 Oct 2011 03:56:22 -0500
Received: from acsinet15.oracle.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id BB118559EB7
	for <xfs@oss.sgi.com>; Mon,  3 Oct 2011 01:56:21 -0700 (PDT)
Received: from acsinet15.oracle.com (acsinet15.oracle.com [141.146.126.227])
	by cuda.sgi.com with ESMTP id 2Bb95QlEi5VCCpOE for
	<xfs@oss.sgi.com>; Mon, 03 Oct 2011 01:56:21 -0700 (PDT)
Message-ID: <4E899BC7.6070607@oracle.com>
Date: Mon, 03 Oct 2011 16:55:59 +0530
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
Subject: Re: [PATCH 3/3] Added test case 259 for the btrfs raid features
References: <4E3BA2F7.4080500@oracle.com> <4E44351D.4020202@oracle.com>
	<20110902084941.GB29054@infradead.org>
In-Reply-To: <20110902084941.GB29054@infradead.org>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-fsdevel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com


Christoph,

  apologies for the delay I was on a long leave.


> Also is there a chance you could allow setting
> only SCRATCH_DEV_POOL for btrfs, and derive SCRATCH_DEV for that as an
> additional step?

  There is some challenge to set SCRATCH_DEV based on FSTYP since
  SCRATCH_DEV is used even before FSTYP is set.

  common.config uses SCRATCH_DEV and we set FSTYP in common.
  check calls these two script files in the following logic.
  --------------------------
  # we need common.config
  if ! . ./common.config
  then
     echo "$iam: failed to source common.config"
     exit 1
  fi

  # we need common
  . ./common
  ---------------------------

  to avoid major changes what we could do is to find-out FSTYP on our
  own in the file common.config and set SCRATCH_DEV based on
  SCRATCH_DEV_POOL, but thats a bit ugly way. I am open to any
  suggestions. thanks.



> Please use the sysfs interface instead of the deprecated /proc/scsi/scsi
> interface.  I would also suggest to split this routine into two for
> removing and adding, and move them to the common helper library, so it
> could be used for other tests.

yes. will get something like below code. in the common

-----
remove:
echo 1 > 
/sys/class/scsi_device/${host}:${channel}:${id}:${lun}/device/delete

add:
echo "$channel $id $lun" > /sys/class/scsi_host/host${host}/scan
-----


>> +# we need this to test removing a dev from the system
>> +_require_proc_scsi()
>> +{
>> +	[ -e /proc/scsi/scsi ]  || _notrun "/proc/scsi/scsi is not present"
>> +}
> 
> The _require need really is that the device you want to work on is a
> SCSI device.

will get this.

Thanks -Anand

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
