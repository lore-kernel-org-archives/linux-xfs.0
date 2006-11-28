Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Fri, 22 Dec 2006 01:51:47 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with SMTP id kBM9pZqw005632
	for <xfs@oss.sgi.com>; Fri, 22 Dec 2006 01:51:37 -0800
Message-ID: <456CCC77.7000001@sgi.com>
Date: Wed, 29 Nov 2006 10:55:35 +1100
From: Donald Douwsma <donaldd@sgi.com>
MIME-Version: 1.0
Subject: Re: get xfs_quota info as regular user
References: <C191AFC3.1D43%rsalmon@tulane.edu>
In-Reply-To: <C191AFC3.1D43%rsalmon@tulane.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Rene Salmon <rsalmon@tulane.edu>
Cc: xfs@oss.sgi.com

Rene Salmon wrote:
> Hi,
> 
> 
> Did some searches on the list archives but could not find any useful info on
> this.
> 
> Is there a way for a regular user to get info about his or her quota usage?
> 
> I tried both of these as a regular user and get nothing:
> 
> 120> xfs_quota -c "quota userid"
> 121> xfs_quota -x -c "quota userid"

By default the quota command does not display anything unless the user is overquota.
To display the limits set for a user you need to specify the -v option.

xfs_quota -c 'quota -v'

Note there is currently a bug in xfs-cmds that causes xfs_quota to display results multiple times
(once for each xfs filesystem). One work around for this is to specify the specific filesystem on
the commandline.

xfs_quota -c 'quota -v' /home

Donald
