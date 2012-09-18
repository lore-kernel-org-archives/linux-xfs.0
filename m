Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q8I8U3fq027978 for <xfs@oss.sgi.com>; Tue, 18 Sep 2012 03:30:04 -0500
Received: from smtprelay05.ispgateway.de (smtprelay05.ispgateway.de
	[80.67.31.100]) by cuda.sgi.com with ESMTP id wg3waMfkfLVcTWFP
	for <xfs@oss.sgi.com>; Tue, 18 Sep 2012 01:31:14 -0700 (PDT)
Message-ID: <5058314F.7000102@cape-horn-eng.com>
Date: Tue, 18 Sep 2012 10:31:11 +0200
From: Richard Ems <richard.ems@cape-horn-eng.com>
MIME-Version: 1.0
Subject: Re: XFS (sdd1): Internal error xfs_da_do_buf(2) at line 2097 of file
	/usr/src/packages/BUILD/kernel-default-3.3.6/linux-3.3/fs/xfs/xfs_da_btree.c.
References: <50573A13.7000206@cape-horn-eng.com>
	<20120917234926.GJ13691@dastard>
In-Reply-To: <20120917234926.GJ13691@dastard>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com

On 09/18/2012 01:49 AM, Dave Chinner wrote:
> On Mon, Sep 17, 2012 at 04:56:19PM +0200, Richard Ems wrote:
>> Hi all,
>>
>> saturday morning one hard disc on our RAID6 failed. About one hour later,
>>  the XFS running on that device reported the following error:
>>
>> XFS (sdd1): Internal error xfs_da_do_buf(2) at line 2097 of file /usr/sr=
c/packages/BUILD/kernel-default-3.3.6/linux-3.3/fs/xfs/xfs_da_btree.c.
> .....
>> Sep 15 07:30:51 fs1 kernel: [7369085.792619] XFS (sdd1): Corruption dete=
cted. Unmount and run xfs_repair
>>
>>
>> And this repeating again and again ...
>>
>> This system has been running fine for 87 days, no power outages or such.
>> It's connected to an UPS, and the H800 Raid Controller has a BBU install=
ed.
> .....
>> Why could this have happened?
> =

> Something went wrong at the RAID level (i.e. your hardware) in
> handling the disk failure and recovering the array. It corrupted
> blocks in the volume rather than recovering them cleanly without
> errors. The corrupted blocks happened to be in a directory block,
> and a frequently accessed one according to the errors in the log.
> =

> What you found in lost+found was the recoverable fragments of the
> directory and whatever else was corrupted during the disk failure
> incident.
> =

>> What more info can I provide to understand this issue and avoid
>> this to happen again?
> =

> I'd be asking your hardware vendor about why it corrupted the
> volume on a single disk failure when it is supposed to be able to
> transparently handle double disk failures without losing/corrupting
> data.
> =

> Cheers,
> =

> Dave.
> =


Ok, many thanks Dave. I will forward this conversation to the DELL guys ...

Thanks again,
Richard


-- =

Richard Ems       mail: Richard.Ems@Cape-Horn-Eng.com

Cape Horn Engineering S.L.
C/ Dr. J.J. D=F3mine 1, 5=BA piso
46011 Valencia
Tel : +34 96 3242923 / Fax 924
http://www.cape-horn-eng.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
