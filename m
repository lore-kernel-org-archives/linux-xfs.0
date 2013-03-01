Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 67CED7F60
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 17:51:11 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 51D278F8052
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 15:51:11 -0800 (PST)
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com
	[66.111.4.25]) by cuda.sgi.com with ESMTP id XKvgDujgx4RmTJDd
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Fri, 01 Mar 2013 15:51:10 -0800 (PST)
Date: Fri, 1 Mar 2013 15:51:08 -0800
From: Greg KH <greg@kroah.com>
Subject: Re: [STABLE] [PATCH] xfs: xfs_bmap_add_attrfork_local is too generic
Message-ID: <20130301235108.GB11455@kroah.com>
References: <20130301232941.GJ30652@sgi.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20130301232941.GJ30652@sgi.com>
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
To: Ben Myers <bpm@sgi.com>
Cc: dchinner@redhat.com, stable@vger.kernel.org, xfs@oss.sgi.com

On Fri, Mar 01, 2013 at 05:29:41PM -0600, Ben Myers wrote:
> Hi,
> 
> Please take this fix for 3.8-stable.  It resolves a problem with write
> verifiers and symlinks which results in a forced unmount.

Now applied, I've snuck it into 3.8.2.

greg k-h

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
