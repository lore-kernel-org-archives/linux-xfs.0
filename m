Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 6BB8D7CA0
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2016 22:48:31 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay3.corp.sgi.com (Postfix) with ESMTP id F0385AC002
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2016 20:48:30 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 66dgjqf9HihVdZ4x for <xfs@oss.sgi.com>;
	Wed, 27 Jul 2016 20:48:27 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 75E74EE6
	for <xfs@oss.sgi.com>; Wed, 27 Jul 2016 22:48:27 -0500 (CDT)
Subject: Re: Any better way to interact with xfs?
References: <SYXPR01MB044863A851C967C37649BE3FF8000@SYXPR01MB0448.ausprd01.prod.outlook.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <082ee469-2a54-3521-2565-8054557d0a80@sandeen.net>
Date: Wed, 27 Jul 2016 22:48:26 -0500
MIME-Version: 1.0
In-Reply-To: <SYXPR01MB044863A851C967C37649BE3FF8000@SYXPR01MB0448.ausprd01.prod.outlook.com>
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
To: xfs@oss.sgi.com

On 7/27/16 10:30 PM, Ryan Lindsay wrote:
> Hi
> 
> I have a bit of a specific requirement.
> 
> I have a server that currently has a 12T worth of data on it on an
> xfs formatted LV.
> 
> currently the file permissions are set via an LDAP, however we are
> having to move to AD for out authentication mechanism. Which will
> change the value of the existing UID's and GID's
> 
> Since XFS has a lot of mechanisms that allow things to happen in
> parallel. I was wondering if there was a way of interacting at the
> file system level to facilitate a change of UID's on files rather
> than having to just chown recursively down the file system. The
> faster I can update the permissions the better basically

Hi Ryan - I'm afraid I don't think there is any lower-level mechanism
to replace permissions, just the normal posix syscalls and
standard tools to invoke them.

You can't convince AD to keep the same numbers?  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
