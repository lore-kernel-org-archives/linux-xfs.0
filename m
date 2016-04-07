Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 601FF7CA0
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 14:08:57 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 25B6D304039
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 12:08:56 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id dCFsmYpPZRuVKkYz for <xfs@oss.sgi.com>;
	Thu, 07 Apr 2016 12:08:55 -0700 (PDT)
Received: from [10.0.0.4] (liberator [10.0.0.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 7928816C165
	for <xfs@oss.sgi.com>; Thu,  7 Apr 2016 14:08:54 -0500 (CDT)
Subject: Re: [PATCH 11/19] mkfs: table based parsing for converted parameters
References: <1458818136-56043-1-git-send-email-jtulak@redhat.com>
	<1458818136-56043-12-git-send-email-jtulak@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <5706B046.9020500@sandeen.net>
Date: Thu, 7 Apr 2016 14:08:54 -0500
MIME-Version: 1.0
In-Reply-To: <1458818136-56043-12-git-send-email-jtulak@redhat.com>
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



On 3/24/16 6:15 AM, jtulak@redhat.com wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> CHANGE:
> o Change getnum_checked type to long long to prevent int overflow
> o Add description of new members in opt_params struct.
> o L_SU maxval was a wrong number, fix it
> 
> All the parameters that can be passed as block or sector sizes need
> to be passed the block and sector sizes that they should be using
> for conversion. For parameter parsing, it is always the same two
> variables, so to make things easy just declare them as global
> variables so we can avoid needing to pass them to getnum_checked().
> 
> We also need to mark these parameters are requiring conversion so
> that we don't need to pass this information manually to
> getnum_checked(). Further, some of these options are required to
> have a power of 2 value, so add optional checking for that as well.
> 
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> Signed-off-by: Jan Tulak <jtulak@redhat.com>

Reviewed-by: Eric Sandeen <sandeen@redhat.com>

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
