Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (8.14.3/8.14.3/SuSE Linux 0.8) with ESMTP id
	n2D2SfWR112840 for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 21:29:01 -0500
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com
	[134.14.52.130])
	by relay3.corp.sgi.com (Postfix) with SMTP id 6F523AC01D
	for <xfs@oss.sgi.com>; Thu, 12 Mar 2009 19:28:18 -0700 (PDT)
Message-ID: <49B9C2BD.8070802@sgi.com>
Date: Fri, 13 Mar 2009 13:19:41 +1100
From: Greg Banks <gnb@sgi.com>
MIME-Version: 1.0
Subject: Re: issues with project quota over nfs
References: <296855.89556.qm@web31805.mail.mud.yahoo.com>
In-Reply-To: <296855.89556.qm@web31805.mail.mud.yahoo.com>
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
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: brian wince <bswince@yahoo.com>
Cc: xfs@oss.sgi.com

brian wince wrote:
> All,
> We have a Quad-core server running gentoo 2.6.27-r7 that is used as an
> nfs server for a xfs partition.
> We are using project quota's on directories within this partition and
> exporting this.
> When a client tries to untar in the dir with project quotas set and
> reaches the quota limit the load on the NFS server goes up
> dramatically and stays like this for a few minutes after the tar has
> gone through trying to write all of it files and failing due to quota
> limit exceeded.
>  
> Is this a known issue and if so is there anything that can be done to
> resolve this.

You probably want to update the client kernels to have this commit:

http://git.kernel.org/?p=linux%2Fkernel%2Fgit%2Ftorvalds%2Flinux-2.6.git&a=commit&h=7b159fc18d417980f57aef64cab3417ee6af70f8
>  
> We do not see this issue if on the locally mounted partition. This
> only happens over NFS.
>  
> Please let me know if you need more information or if this should be
> addressed on a different list.

You should ask NFS questions on the NFS list, linux-nfs@vger.kernel.org.

-- 
Greg Banks, P.Engineer, SGI Australian Software Group.
the brightly coloured sporks of revolution.
I don't speak for SGI.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
