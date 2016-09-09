Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 235A37CA1
	for <xfs@oss.sgi.com>; Fri,  9 Sep 2016 01:42:08 -0500 (CDT)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id C7E50304043
	for <xfs@oss.sgi.com>; Thu,  8 Sep 2016 23:42:07 -0700 (PDT)
Received: from smtprelay.hostedemail.com (smtprelay0075.hostedemail.com
	[216.40.44.75]) by cuda.sgi.com with ESMTP id Io01gtZWc4uNJlKQ
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 Sep 2016 23:42:04 -0700 (PDT)
Message-ID: <1473403321.13672.35.camel@perches.com>
Subject: Re: [PATCH] xfs: fix signed integer overflow
From: Joe Perches <joe@perches.com>
Date: Thu, 08 Sep 2016 23:42:01 -0700
In-Reply-To: <1473403112-31072-1-git-send-email-xiexiuqi@huawei.com>
References: <1473403112-31072-1-git-send-email-xiexiuqi@huawei.com>
Mime-Version: 1.0
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
To: Xie XiuQi <xiexiuqi@huawei.com>, david@fromorbit.com
Cc: linux-kernel@vger.kernel.org, xfs@oss.sgi.com

On Fri, 2016-09-09 at 14:38 +0800, Xie XiuQi wrote:
> Use 1U for unsigned long, or we'll meet a overflow issue with UBSAN.

trivia: misleading commit message

1U is for unsigned int not unsigned long int


_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
