Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	q2FGqMdA155648 for <xfs@oss.sgi.com>; Thu, 15 Mar 2012 11:52:22 -0500
Received: from mail-lb0-f181.google.com (mail-lb0-f181.google.com
	[209.85.217.181]) by cuda.sgi.com with ESMTP id
	0ZMG371nCLCnfxDX (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 15 Mar 2012 09:52:20 -0700 (PDT)
Received: by lbok6 with SMTP id k6so1774139lbo.26
	for <xfs@oss.sgi.com>; Thu, 15 Mar 2012 09:52:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120315152548.GA25194@www5.open-std.org>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<20321.63389.586851.689070@tree.ty.sabi.co.UK>
	<20120315152548.GA25194@www5.open-std.org>
Date: Fri, 16 Mar 2012 00:52:19 +0800
Message-ID: <CAA8mOyDquGX0kEbQSpo=S0EYdNvXNBQ6ZLnb5Sc7uvCPYB+xqA@mail.gmail.com>
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
From: Jessie Evangelista <jessie.evangelista@gmail.com>
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
To: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>

Hi keld,

On Thu, Mar 15, 2012 at 11:25 PM,  <keld@keldix.com> wrote:
> On Thu, Mar 15, 2012 at 02:07:25PM +0000, Peter Grandi wrote:
>> >>> I want to create a raid10,n2 using 3 1TB SATA drives.
>> >>> I want to create an xfs filesystem on top of it. The
>> >>> filesystem will be used as NFS/Samba storage.
>>
>> Consider also an 'o2' layout (it is probably the same thing for a
>> 3 drive RAID10) or even a RAID5, as 3 drives and this usage seems
>> one of the few cases where RAID5 may be plausible.
>
> Well, for a file server like NFS/Samba, you could also consider raid10,f2.
> I would think you could get about double the read performance compared to=
 n2 and o2
> layouts, and also for individual read transfers on a running system
> you would get somthing like double the read performance.
> Write performance could be somewhat slower (0 to 10 %) bot as users
> are not waiting for writes to complete, they will probably not notice.

I also plan to try raid10f2. Did you do your own benchmarks or are you
quoting someone elses?
>
> best regards
> keld

thanks for chiming in. have a nice day

> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
