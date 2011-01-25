Return-Path: <xfs-bounces@oss.sgi.com>
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	p0PCgwUR005829 for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 06:42:58 -0600
Received: from mail-out.m-online.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id D906428AD70
	for <xfs@oss.sgi.com>; Tue, 25 Jan 2011 04:45:13 -0800 (PST)
Received: from mail-out.m-online.net (mail-out.m-online.net [212.18.0.9]) by
	cuda.sgi.com with ESMTP id OLTq3sVx38HSBDnE for
	<xfs@oss.sgi.com>; Tue, 25 Jan 2011 04:45:13 -0800 (PST)
From: Wolfgang Denk <wd@denx.de>
Subject: Re: Optimize RAID0 for max IOPS?
MIME-Version: 1.0
In-reply-to: <20110125083643.GE28803@dastard>
References: <20110118210112.D13A236C@gemini.denx.de>
	<4D361F26.3060507@stud.tu-ilmenau.de>
	<20110119192104.1FA92D30267@gemini.denx.de>
	<AANLkTikx4g99-Cf_09kEGfF2mmf4Dnuh2A5gTrtKweDy@mail.gmail.com>
	<alpine.DEB.2.00.1101241024230.14640@p34.internal.lan>
	<20110124215713.82D75B187@gemini.denx.de>
	<20110124230314.GA11040@dastard>
	<20110125083900.4dd65bf2@galadriel2.home>
	<20110125083643.GE28803@dastard>
Date: Tue, 25 Jan 2011 13:45:09 +0100
Message-Id: <20110125124509.D76D6BB0B9@gemini.denx.de>
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
To: Dave Chinner <david@fromorbit.com>
Cc: linux-raid@vger.kernel.org, Justin Piszcz <jpiszcz@lucidpixels.com>, xfs@oss.sgi.com

Dear Dave Chinner,

In message <20110125083643.GE28803@dastard> you wrote:
>
> Oh, despite $subject being "RAID0" the filesystems being tested are
> on RAID5 and RAID6 with very small chunk sizes on slow SATA drives.
> This is smelling like a case of barrier IOs on software raid on
> cheap storage....

Right. [Any way to avoid these, btw?]  I got side-tracked by the
comments about the new (to me) delaylog mount option to xfs; as the
results were not exactly as exp[ected I though it might be interesting
to report these.

But as the subject says, my current topic is tuning RAID0 to avoid
exactly this type of bottleneck; or rather looking for tunable options
on RAID0

Best regards,

Wolfgang Denk

--
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
PLEASE NOTE: Some Quantum Physics Theories Suggest That When the Con-
sumer Is Not Directly Observing This Product, It May Cease  to  Exist
or Will Exist Only in a Vague and Undetermined State.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
