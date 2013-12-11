Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 3BD577F4E
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 12:53:01 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 1A86B304075
	for <xfs@oss.sgi.com>; Wed, 11 Dec 2013 10:52:57 -0800 (PST)
Received: from slmp-550-94.slc.westdc.net (slmp-550-94.slc.westdc.net
	[50.115.112.57]) by cuda.sgi.com with ESMTP id sxrk65BdWI2mjMVX
	(version=TLSv1 cipher=AES256-SHA bits=256 verify=NO) for
	<xfs@oss.sgi.com>; Wed, 11 Dec 2013 10:52:55 -0800 (PST)
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: XFS: Internal error XFS_WANT_CORRUPTED_RETURN
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20131211172725.GA4606@redhat.com>
Date: Wed, 11 Dec 2013 11:52:51 -0700
Message-Id: <68DD7157-6ACE-4548-A466-C1EBD31B6DEB@colorremedies.com>
References: <20131211172725.GA4606@redhat.com>
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
To: Dave Jones <davej@redhat.com>
Cc: xfs@oss.sgi.com


On Dec 11, 2013, at 10:27 AM, Dave Jones <davej@redhat.com> wrote:
> 
> Thoughts ? Could sda be dying ? (It is a fairly old crappy ssd)

It may reveal nothing useful, but please report the results from 'smartctl -x /dev/sda' and if not found install smartmontools package.


Chris Murphy
_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
