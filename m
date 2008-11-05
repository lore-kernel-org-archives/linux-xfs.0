Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 04 Nov 2008 20:32:57 -0800 (PST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.168.28])
	by oss.sgi.com (8.12.11.20060308/8.12.11/SuSE Linux 0.7) with ESMTP id mA54WeDx005682
	for <xfs@oss.sgi.com>; Tue, 4 Nov 2008 20:32:40 -0800
Received: from sandeen.net (localhost [127.0.0.1])
	by cuda.sgi.com (Spam Firewall) with ESMTP id 60081111C062
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2008 20:32:42 -0800 (PST)
Received: from sandeen.net (sandeen.net [209.173.210.139]) by cuda.sgi.com with ESMTP id QWFsq8PDeH5ccvsK for <xfs@oss.sgi.com>; Tue, 04 Nov 2008 20:32:42 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTP id B48F9A81F0B
	for <xfs@oss.sgi.com>; Tue,  4 Nov 2008 22:32:41 -0600 (CST)
Message-ID: <491121E9.5000608@sandeen.net>
Date: Tue, 04 Nov 2008 22:32:41 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: mount with security context if SELinux is enabled
References: <49107592.3030800@sandeen.net>
In-Reply-To: <49107592.3030800@sandeen.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: xfs mailing list <xfs@oss.sgi.com>

Eric Sandeen wrote:
> When SELinux is enabled, it adds extra xattrs for security
> attributes which can change the output of various tests, causing
> them to fail.
> 
> If SELinux is enabled, mount with a liberal/permissive context
> for the entire filesystem, so that SELinux xattrs don't get
> created.
> 
> Signed-off-by: Eric Sandeen <sandeen@sandeen.net>
> ---

hold off on this one, I've needed to make a few more changes.

Thanks,
-Eric
