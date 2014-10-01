Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 7E2F97F7C
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 21:48:51 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F1CE2AC00D
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 19:48:50 -0700 (PDT)
Received: from mail-wi0-f175.google.com (mail-wi0-f175.google.com
	[209.85.212.175]) by cuda.sgi.com with ESMTP id
	51S6Pa4NMwBbenFz (version=TLSv1 cipher=RC4-SHA bits=128
	verify=NO) for <xfs@oss.sgi.com>;
	Tue, 30 Sep 2014 19:48:46 -0700 (PDT)
Received: by mail-wi0-f175.google.com with SMTP id d1so472859wiv.14
	for <xfs@oss.sgi.com>; Tue, 30 Sep 2014 19:48:45 -0700 (PDT)
Received: from [192.168.1.14] (177.Red-79-159-63.staticIP.rima-tde.net.
	[79.159.63.177])
	by mx.google.com with ESMTPSA id ul1sm21090988wjc.9.2014.09.30.19.48.44
	for <xfs@oss.sgi.com>
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
	Tue, 30 Sep 2014 19:48:44 -0700 (PDT)
Message-ID: <542B6B8A.2060309@opensuse.org>
Date: Wed, 01 Oct 2014 04:48:42 +0200
From: "Carlos E. R." <carlos.e.r@opensuse.org>
MIME-Version: 1.0
Subject: Re: Happened again,
	20140930 -- Got "Internal error XFS_WANT_CORRUPTED_GOTO".
	Filesystem needs reformatting to correct issue.
References: <alpine.LSU.2.11.1407021104480.9881@Telcontar.valinor>	<alpine.LSU.2.11.1408111559280.2447@minas-tirith.valinor>	<alpine.LSU.2.11.1410010001350.17407@minas-tirith.valinor>
	<20141001004514.GH24490@dastard>
In-Reply-To: <20141001004514.GH24490@dastard>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: XFS mailing list <xfs@oss.sgi.com>

On 2014-10-01 02:45, Dave Chinner wrote:
> On Wed, Oct 01, 2014 at 12:27:20AM +0200, Carlos E. R. wrote:

> We've already got the fix in our upstream repository:
>
> 8018ec0 xfs: mark all internal workqueues as freezable
>
> It's currently in linux-next, queued for the next merge window. You
> shoul dprobably talk to your distro about getting it backported.

Wow, thanks. I'll tell them.

Question: where does it apply, kernel, xfsprogs? They will know, but I don't, and I need that info 
for the bugzilla "component" field ;-)

-- 
Cheers / Saludos,

		Carlos E. R.
		(from 13.1 x86_64 "Bottle" (Elessar))

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
