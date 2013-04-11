Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 64ED07F37
	for <xfs@oss.sgi.com>; Thu, 11 Apr 2013 17:17:58 -0500 (CDT)
Date: Thu, 11 Apr 2013 17:17:55 -0500
From: Ben Myers <bpm@sgi.com>
Subject: Re: Deprecating xfs_check
Message-ID: <20130411221754.GI22182@sgi.com>
References: <1365716708.3762.32154.camel@chandra-dt.ibm.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <1365716708.3762.32154.camel@chandra-dt.ibm.com>
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
Cc: XFS mailing list <xfs@oss.sgi.com>

Hey Chandra,

On Thu, Apr 11, 2013 at 04:45:08PM -0500, Chandra Seetharaman wrote:
> Hello All,
> 
> Alex Elder mentioned about deprecating xfs_check, and he suggested is to
> replace xfs_check command with a script, that says xfs_check is
> deprecated, use "xfs_repair -n".
> 
> Sounds ok ?
> 
> Let me know if it is not the right approach.

That sounds ok to me.  You might also consider making xfs_check a hardlink to
xfs_repair and varying the behavior based on program name.  Then xfs_check ==
xfs_repair -n.

Regards,
	Ben

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
