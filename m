Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 32C397F53
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 21:26:11 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay3.corp.sgi.com (Postfix) with ESMTP id C0881AC001
	for <xfs@oss.sgi.com>; Sun,  1 Nov 2015 19:26:07 -0800 (PST)
Received: from mx3-phx2.redhat.com (mx3-phx2.redhat.com [209.132.183.24]) by
	cuda.sgi.com with ESMTP id HarF4HafDwsoZpNJ (version=TLSv1
	cipher=DHE-RSA-AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 01 Nov 2015 19:26:05 -0800 (PST)
Date: Sun, 1 Nov 2015 22:25:58 -0500 (EST)
From: Nathan Scott <nathans@debian.org>
Message-ID: <1847596501.219026.1446434758818.JavaMail.zimbra@redhat.com>
In-Reply-To: <56362B71.4070709@calhariz.com>
References: <56362B71.4070709@calhariz.com>
Subject: Re: Problems compiling xfsdump on Debian unstable
MIME-Version: 1.0
Reply-To: Nathan Scott <nathans@debian.org>
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
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Jose M Calhariz <jose@calhariz.com>
Cc: xfs@oss.sgi.com

Hi Jose,

----- Original Message -----
> I am trying to compile the latest xfsdump from the git repository.

The underlying problem was related to changes in xfsprogs header files
which had unanticipated dependencies in xfsdump - Dave has been working
through all these issues (iow, removing the unanticipated dependencies,
by updating xfsdump code) and the next release of xfsdump will resolve
this build failure.  It's not a trivial change though, so our best bet
(IMO) is to wait on those upstream changes from Dave and then get a new
package build into unstable & testing.

cheers.

--
Nathan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
