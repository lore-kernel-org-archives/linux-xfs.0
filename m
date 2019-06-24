Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:60004 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728417AbfFXOqb (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 24 Jun 2019 10:46:31 -0400
Date: Mon, 24 Jun 2019 07:45:58 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: Re: [PATCH] xfs_quota: fix built-in help for project setup
Message-ID: <20190624144558.GE5387@magnolia>
References: <8b7e8e8d-0297-caff-568e-c9d1e75eda63@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b7e8e8d-0297-caff-568e-c9d1e75eda63@redhat.com>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-xfs <linux-xfs@vger.kernel.org>

On Mon, Jun 24, 2019 at 08:55:38AM -0500, Eric Sandeen wrote:
> -s is used to set up a new project, not -c.
> 
> Signed-off-by: Eric Sandeen <sandeen@redhat.com>

Looks ok,
Reviewed-by: Darrick J. Wong <darrick.wong@oracle.com>

--D

> ---
> 
> diff --git a/quota/project.c b/quota/project.c
> index 7c22947..03ae10d 100644
> --- a/quota/project.c
> +++ b/quota/project.c
> @@ -43,7 +43,7 @@ project_help(void)
>  " and subdirectories below it (i.e. a tree) can be restricted to using a\n"
>  " subset of the available space in the filesystem.\n"
>  "\n"
> -" A managed tree must be setup initially using the -c option with a project.\n"
> +" A managed tree must be setup initially using the -s option with a project.\n"
>  " The specified project name or identifier is matched to one or more trees\n"
>  " defined in /etc/projects, and these trees are then recursively descended\n"
>  " to mark the affected inodes as being part of that tree - which sets inode\n"
> 
