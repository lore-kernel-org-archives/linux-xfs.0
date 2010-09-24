Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	o8OF9vn2187696 for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 10:09:57 -0500
Received: from mail-gy0-f181.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 182DD1BABD4D
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 08:10:52 -0700 (PDT)
Received: from mail-gy0-f181.google.com (mail-gy0-f181.google.com
	[209.85.160.181]) by cuda.sgi.com with ESMTP id
	dozQXyl1SrDIpvS0 for <xfs@oss.sgi.com>;
	Fri, 24 Sep 2010 08:10:52 -0700 (PDT)
Received: by gyf1 with SMTP id 1so1200357gyf.26
	for <xfs@oss.sgi.com>; Fri, 24 Sep 2010 08:10:52 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20100924075505.GA24664@infradead.org>
References: <4C9B5786.4010205@open-e.com> <20100923143221.GA1989@infradead.org>
	<4C9B6B27.5050606@open-e.com>
	<20100924075505.GA24664@infradead.org>
Date: Fri, 24 Sep 2010 08:10:51 -0700
Message-ID: <AANLkTimXCo0YtjmdPo9RvX=KfQCjJkkL9hQr3h63UJX7@mail.gmail.com>
Subject: Re: Problem with file system on iSCSI FileIO
From: Richard Sharpe <realrichardsharpe@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Artur Piechocki <artur.piechocki@open-e.com>, ??ukasz Wittig <lukasz.wittig@open-e.com>, Slawomir Nowakowski <slawomir.nowakowski@open-e.com>, Ryszard Stawiarski <ryszard.stawiarski@open-e.com>, xfs@oss.sgi.com

On Fri, Sep 24, 2010 at 12:55 AM, Christoph Hellwig <hch@infradead.org> wro=
te:
> On Thu, Sep 23, 2010 at 04:58:47PM +0200, Slawomir Nowakowski wrote:
>> iSCSI FileIO is using struct file that serves it as block level
>> device via iSCSI technology:
>>
>> http://en.wikipedia.org/wiki/ISCSI
>
> Thanks, I know ISCSI very well. =A0But what is "iSCSI FileIO" ? =A0The ab=
ove
> sounds like it's an iscsi target, is that correct?
>
>> There are RAID level 6 unit on the Areca RAID controller (1680). On
>> the unit is created a volume group. In the volume group we have
>> several logical volumes. The iSCSI FileIO volume is mounted and the
>> file (lun) is served via SCST target as iSCSI LUN.
>>
>> We have checked RAM with memtest+ and verified RAID unit health and
>> no issues were found.
>
> I still can't make any sense of the actual setups.
>
> The above seems to be the backend storage. =A0Then there's SCST somewhere
> in which is in a out of tree kernel module. =A0And then you use XFS
> somewhere. =A0Please provide a full description of the setup.

Sounds like iSCSI-SCST to a vdisk_fileio on a file under xfs on a LUN
on the Areca RAID controller ...

Does sound awfully complicated. Why not just serve the LUNs from the
Areca directly? SCST allows you to do that. xfs is awesomely fast, but
it is just adding overhead here.


-- =

Regards,
Richard Sharpe

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
