Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id AC8657F3F
	for <xfs@oss.sgi.com>; Thu, 11 Jul 2013 10:48:36 -0500 (CDT)
Date: Thu, 11 Jul 2013 10:48:32 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: [PATCH v11 1/4] xfs: Add pquota fields where gquota is used.
Message-ID: <20130711154832.GB20932@sgi.com>
References: <1373518843-1492-1-git-send-email-sekharan@us.ibm.com>
	<1373518843-1492-2-git-send-email-sekharan@us.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1373518843-1492-2-git-send-email-sekharan@us.ibm.com>
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
To: Chandra Seetharaman <sekharan@us.ibm.com>
Cc: xfs@oss.sgi.com

On Thu, Jul 11, 2013 at 12:00:40AM -0500, Chandra Seetharaman wrote:
> Add project quota changes to all the places where group quota field
> is used:
>    * add separate project quota members into various structures
>    * split project quota and group quotas so that instead of overriding
>      the group quota members incore, the new project quota members are
>      used instead
>    * get rid of usage of the OQUOTA flag incore, in favor of separate
>      group and project quota flags.
>    * add a project dquot argument to various functions.
> 
> Not using the pquotino field from superblock yet.
> 
> Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>

Looks good.  Applied.

Reviewed-by: Ben Myers <bpm@sgi.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
