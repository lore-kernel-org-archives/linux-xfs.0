Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 14 Jun 2007 07:29:40 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l5EETaWt029636
	for <xfs@oss.sgi.com>; Thu, 14 Jun 2007 07:29:37 -0700
Message-ID: <467150D3.7090109@sandeen.net>
Date: Thu, 14 Jun 2007 09:29:39 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Review: dmapi-devel RPM should required xfsprogs-devel RPM
References: <op.ttwa4bv73jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.ttwa4bv73jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>

Barry Naujok wrote:
> As per the subject (and also mentioned in the description):
> 
> --- a/dmapi/build/rpm/dmapi.spec.in     2007-06-14 15:02:13.000000000 +1000
> +++ b/dmapi/build/rpm/dmapi.spec.in     2007-06-14 14:47:31.290063558 +1000
> @@ -23,7 +23,7 @@
>   %package devel
>   Summary: Data Management API static libraries and headers.
>   Group: Development/Libraries
> -Requires: @pkg_name@ >= 2.0.4
> +Requires: @pkg_name@ >= 2.0.4 xfsprogs-devel
> 
>   %description devel
>   dmapi-devel contains the libraries and header files needed to
> 
> 

seems sane to me.  Just a header issue I guess?

-eric
