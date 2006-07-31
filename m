Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 30 Jul 2006 17:59:40 -0700 (PDT)
Received: from mx1.suse.de (mx1.suse.de [195.135.220.2])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k6V0tlDW007357
	for <xfs@oss.sgi.com>; Sun, 30 Jul 2006 17:59:09 -0700
From: Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] kill leftover WANT_FUNCS macro indirection
Date: Mon, 31 Jul 2006 02:54:27 +0200
References: <44CAE247.6020608@sandeen.net> <20060731085454.A2280998@wobbly.melbourne.sgi.com> <44CD3DF2.1010108@melbourne.sgi.com>
In-Reply-To: <44CD3DF2.1010108@melbourne.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200607310254.27448.ak@suse.de>
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: chatz@melbourne.sgi.com
Cc: Nathan Scott <nathans@sgi.com>, Eric Sandeen <sandeen@sandeen.net>, xfs@oss.sgi.com

> 
> 
> Sam on his previous project had to do significant cleanup/macro
> changes and wrote some tools to help him do post-preprocessor
> comparisons to really look at what had changed. I'm not sure how
> generic these tools are, but worth considering.

In this particular case you can just compare .o or .s files. They should be 
identical.

-Andi
