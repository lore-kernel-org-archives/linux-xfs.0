Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 25 Sep 2008 09:28:35 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m8PGSWxf022006
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 09:28:32 -0700
Received: from minas.ics.muni.cz (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 84C1797E791
	for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 09:30:06 -0700 (PDT)
Received: from minas.ics.muni.cz (minas.ics.muni.cz [147.251.4.40]) by cuda.sgi.com with ESMTP id U4YFgWCF38cfoMFr for <xfs@oss.sgi.com>; Thu, 25 Sep 2008 09:30:06 -0700 (PDT)
Date: Thu, 25 Sep 2008 18:30:24 +0200
From: Lukas Hejtmanek <xhejtman@ics.muni.cz>
Subject: Re: 2.6.27-rc7 no init found on the root partition?
Message-ID: <20080925163024.GP31582@ics.muni.cz>
References: <20080924192227.GC31582@ics.muni.cz> <20080924230326.GM5448@disturbed> <20080925111239.GF31582@ics.muni.cz> <48DB96B8.6050503@sandeen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <48DB96B8.6050503@sandeen.net>
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Thu, Sep 25, 2008 at 08:48:40AM -0500, Eric Sandeen wrote:
> Is it possible that device ordering has changed?  what if you do:

no, using printk's I found that search_binary_handler is the one that fails.
Dunno why.

-- 
Luká¹ Hejtmánek
