Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Tue, 15 Aug 2006 07:20:29 -0700 (PDT)
Received: from omx1.americas.sgi.com (omx1.americas.sgi.com [198.149.16.13])
	by oss.sgi.com (8.12.10/8.12.10/SuSE Linux 0.7) with ESMTP id k7FEK1DW006505
	for <linux-xfs@oss.sgi.com>; Tue, 15 Aug 2006 07:20:14 -0700
Received: from internal-mail-relay1.corp.sgi.com (internal-mail-relay1.corp.sgi.com [198.149.32.52])
	by omx1.americas.sgi.com (8.12.10/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k7FDL4nx020589
	for <linux-xfs@oss.sgi.com>; Tue, 15 Aug 2006 08:21:04 -0500
Message-ID: <44E1CA29.7080406@sgi.com>
Date: Tue, 15 Aug 2006 08:20:41 -0500
From: Bill Kendall <wkendall@sgi.com>
MIME-Version: 1.0
Subject: Re: Bug in xfsrestore or NFS+XFS Filesystem on NFS Server ? Can anyone
 confirm ?
References: <200608120956.47466.juergen.sauer@automatix.de>
In-Reply-To: <200608120956.47466.juergen.sauer@automatix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-To: xfs-bounce@oss.sgi.com
List-Id: xfs
To: juergen.sauer@automatix.de
Cc: linux-xfs@oss.sgi.com

On 08/12/06 02:56, Juergen Sauer wrote:
> Since that the last restore works, I think there is a bug in xfsrestore or xfs/nfs in the kernel 2.6.17.
> Backupserver, Server, Knoppix are bugfixed 2.6.17(.7). Restoring the dump via nfs failed due "too much open files".
> 
> Does xfsrestore opens really 512k files ? I do not belive that. 
> So It could a problem in Kernel  or NFS Stack be the problem.

Not intentionally, but there could be a file descriptor leak somewhere
in xfsrestore or one of the libraries it uses. Take a look at
/proc/<xfsrestore pid>/fd while the restore is going on and see if the
file descriptor list is growing. If so, it should indicate what files
are being opened but not closed.

Bill
