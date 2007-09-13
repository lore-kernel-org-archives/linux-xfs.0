Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 13 Sep 2007 07:49:43 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [66.187.233.31])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id l8DEnT4p010652
	for <xfs@oss.sgi.com>; Thu, 13 Sep 2007 07:49:34 -0700
Message-ID: <46E94DEC.3090404@sandeen.net>
Date: Thu, 13 Sep 2007 09:49:16 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: Configuring XFS on Redhat Linux
References: <53F49A183F99D94D9C84E062566A97E3037C6E1E@SGPPCMEU302VEUA.INTRANET.BARCAPINT.COM>
In-Reply-To: <53F49A183F99D94D9C84E062566A97E3037C6E1E@SGPPCMEU302VEUA.INTRANET.BARCAPINT.COM>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Kumaraswamy.Namburu@barclayscapital.com
Cc: xfs@oss.sgi.com

Kumaraswamy.Namburu@barclayscapital.com wrote:
> Hello All,
> 
>   Following is the configuration of the server
>   Linux version 2.6.9-22.ELsmp (root@yort.fnal.gov) (gcc version 3.4.3 20050227 (Red Hat 3.4.3-22.1)) #1 SMP Thu Oct 6 10:29:1
>   Linux engpsrcn01.intranetdev.barcapdev.com 2.6.9-22.ELsmp #1 SMP Thu Oct 6 10:29:17 CDT 2005 x86_64 x86_64 x86_64 GNU/Linux
>   From Inside our compant, I am unable to connect to cvs server at port 2041. Could you please let me know the alternative ways to get the source code.

unless you really need cvs, how about http via kernel.org?  or the git
tree? http://oss.sgi.com/cgi-bin/gitweb.cgi?p=xfs/xfs-2.6.git

If you want xfs for your 2.6.9-22.ELsmp kernel, you might just grab the
xfs kernel module packages & xfs userspace from the Centos distribution.

Or, since it looks like you're using scientific linux and not actually
RHEL, maybe just ask them.

-Eric
