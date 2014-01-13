Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id F41F029DF8
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 22:44:15 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id CFAFC8F8050
	for <xfs@oss.sgi.com>; Sun, 12 Jan 2014 20:44:12 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 1G9VGYr8uR8CcQVh for <xfs@oss.sgi.com>;
	Sun, 12 Jan 2014 20:44:11 -0800 (PST)
Message-ID: <52D36F19.3070207@sandeen.net>
Date: Sun, 12 Jan 2014 22:44:09 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfstests: Add pairing mount options test
References: <1389162648-19309-1-git-send-email-quwenruo@cn.fujitsu.com>
	<52D01CA9.4040107@sandeen.net> <52D33F92.2000609@cn.fujitsu.com>
	<52D342F0.5020402@sandeen.net> <20140113015239.GD3469@dastard>
	<52D34EBD.4020508@cn.fujitsu.com> <20140113032650.GH3469@dastard>
	<52D364DA.4000708@cn.fujitsu.com>
In-Reply-To: <52D364DA.4000708@cn.fujitsu.com>
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
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Dave Chinner <david@fromorbit.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-btrfs <linux-btrfs@vger.kernel.org>, xfs@oss.sgi.com

On 1/12/14, 10:00 PM, Qu Wenruo wrote:
> Now I'm interested in how other filesystems like xfs makes sure that every pairing
> mount options are tested.

For starters, xfs actually doesn't handle very many options during remount.

Many of them are quite tricky to do, which made me wonder if they all
actually worked properly for btrfs.  :)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
