Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Wed, 02 Jul 2008 20:56:21 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m633uAWm001060
	for <xfs@oss.sgi.com>; Wed, 2 Jul 2008 20:56:11 -0700
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 6A2F5A644E5
	for <xfs@oss.sgi.com>; Wed,  2 Jul 2008 20:57:14 -0700 (PDT)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id A6AKOiWz2kPSJoSe for <xfs@oss.sgi.com>; Wed, 02 Jul 2008 20:57:14 -0700 (PDT)
Message-ID: <486C4E19.6080203@sandeen.net>
Date: Wed, 02 Jul 2008 22:57:13 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: XFS Compatibility Questions
References: <0EEA30D7D649274EB38B0B140022557F23B36C@corpistemb01.edocorp.com>
In-Reply-To: <0EEA30D7D649274EB38B0B140022557F23B36C@corpistemb01.edocorp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: "Arensdorf, Christopher" <Chris.Arensdorf@itt.com>
Cc: xfs@oss.sgi.com

Arensdorf, Christopher wrote:
> Hello,
> 
> My name is Chris and I'm with ITT Corporation in Nashua, NH. We're currently looking to upgrade one of our products to make use of InfiniBand technology, and unfortunately we're running QFS which does not support InfiniBand. We're interested in exploring the idea of using XFS so I had a few questions I was hoping you might be able to answer that I didn't seem to find in the FAQ section.
> 
> Is XFS compatible with InfiniBand?

XFS just needs a block device to talk to; the transport to the block
device etc should not matter.

> Is XFS compatible with RHEL 5.0 or higher?

Compatible yes but not supported or shipped by Red Hat.

> Is XFS compatible with Fibre Channel?

See the first answer.  (but anyway the the short answer is Yes.)

> Is XFS compatible with Solaris 10 x86?

AFAIK XFS has never been ported to Solaris.  It's only a production FS
on Linux & Irix.

-Eric

> Thanks very much for your time and I look forward to hearing back from you.
