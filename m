Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Thu, 29 May 2008 03:54:17 -0700 (PDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id m4TAsFu8025111
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 03:54:15 -0700
Received: from smtp8-g19.free.fr (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 91B7EC0907E
	for <xfs@oss.sgi.com>; Thu, 29 May 2008 03:55:07 -0700 (PDT)
Received: from smtp8-g19.free.fr (smtp8-g19.free.fr [212.27.42.65]) by cuda.sgi.com with ESMTP id GrEN8kVb8u0XZeHR for <xfs@oss.sgi.com>; Thu, 29 May 2008 03:55:07 -0700 (PDT)
Date: Thu, 29 May 2008 12:55:09 +0200
From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: free space problem
Message-ID: <20080529125509.136aa653@harpe.intellique.com>
In-Reply-To: <20080529122925.159ddb34@harpe.intellique.com>
References: <20080331093951.100ec125@galadriel.home>
	<20080529102107.73D6D1CA6D0@cuda.sgi.com>
	<20080529122925.159ddb34@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs@oss.sgi.com
Cc: =?ISO-8859-1?Q?Husz=E1r?= Viktor =?ISO-8859-1?Q?D=E9nes?= <hvd@dwo.hu>

Le Thu, 29 May 2008 12:29:25 +0200
Emmanuel Florac <eflorac@intellique.com> écrivait:

> Is it mounted with the inode64 option? 

You should try it then. You must unmount it and remount it for this to
take effect. Either add "inode64" to the option line in /etc/fstab, or
use mount -t xfs -o inode64 /some/device /some/mountpoint

-- 
----------------------------------------
Emmanuel Florac     |   Intellique
----------------------------------------
