Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 03 Jun 2007 01:25:34 -0700 (PDT)
Received: from wa-out-1112.google.com (wa-out-1112.google.com [209.85.146.182])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l538PSWt019301
	for <xfs@oss.sgi.com>; Sun, 3 Jun 2007 01:25:29 -0700
Received: by wa-out-1112.google.com with SMTP id l24so1348090waf
        for <xfs@oss.sgi.com>; Sun, 03 Jun 2007 01:25:28 -0700 (PDT)
Message-ID: <6bffcb0e0706030059o3e53e647uf3ae1aa3f16609d8@mail.gmail.com>
Date: Sun, 3 Jun 2007 09:59:15 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Subject: Re: Kernel 2.6.22-rc3 safe to migrate to?
In-Reply-To: <4661F511.4070207@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Disposition: inline
References: <Pine.LNX.4.64.0706021723480.22318@p34.internal.lan>
	 <4661F511.4070207@goop.org>
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-kernel@vger.kernel.org, xfs@oss.sgi.com

H,
On 03/06/07, Jeremy Fitzhardinge <jeremy@goop.org> wrote:> Justin Piszcz wrote:> > Wondering as their were a lot of XFS related issues early on in> > development..? The 2.6.22-rc3 kernel has the core 2 duo coretemp patch> > by ruik which I want be running as long as 2.6.22-rc3 does not have> > any severe XFS issues?>> XFS currently has a data-corrupting bug, where files which were appended> by small amounts may lose their updates on umount - I see this> corrupting hg repos. There's a patch which works for me, and is in> 2.6.22-rc3-mm1, but it hasn't been merged upstream yet.>
It's already merged into mainline
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=df3c7244264f1d12562413aa32d56be802486516
Regards,Michal
-- "Najbardziej brakowa³o mi twojego milczenia."-- Andrzej Sapkowski "Co¶ wiêcej"
