Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 17 Feb 2008 08:57:48 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m1HGvfdL008632
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 08:57:43 -0800
Received: from fg-out-1718.google.com (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 15134E4495C
	for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 08:58:04 -0800 (PST)
Received: from fg-out-1718.google.com (fg-out-1718.google.com [72.14.220.153]) by cuda.sgi.com with ESMTP id 64mJGzlWG6jrgh87 for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 08:58:04 -0800 (PST)
Received: by fg-out-1718.google.com with SMTP id e12so1069902fga.8
        for <xfs@oss.sgi.com>; Sun, 17 Feb 2008 08:58:03 -0800 (PST)
Message-ID: <6101e8c40802170851w73db8130t9bcfdc5cf053f0dc@mail.gmail.com>
Date: Sun, 17 Feb 2008 17:51:08 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
Subject: Re: xfsaild causing 30+ wakeups/s on an idle system since 2.6.25-rcX
In-Reply-To: <47B863A9.5070206@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Disposition: inline
References: <47B863A9.5070206@gmail.com>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
Cc: xfs@oss.sgi.com, Linux Kernel <linux-kernel@vger.kernel.org>, Arjan van de Ven <arjan@linux.intel.com>, Christoph Lameter <clameter@sgi.com>, David Chinner <dgc@sgi.com>, Christoph Hellwig <hch@infradead.org>

On 2/17/08, Török Edwin <edwintorok@gmail.com> wrote:
> Hi,
>
> xfsaild is causing many wakeups, a quick investigation shows
> xfsaild_push is always
> returning 30 msecs timeout value.
>
> This is on an idle system, running only gnome, and gnome-terminal.
>
> I suggest changing the timeout logic in xfsaild to be more power
> consumption friendly.
>
> See below my original report to the powerTOP mailing list.
>
> Best regards,
> --Edwin
>


-- 
Thanks,
Oliver
