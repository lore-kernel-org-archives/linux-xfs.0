Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 9EC3E7F55
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 03:57:10 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 7F3138F804C
	for <xfs@oss.sgi.com>; Thu,  8 May 2014 01:57:10 -0700 (PDT)
Received: from mx2.suse.de (cantor2.suse.de [195.135.220.15]) by cuda.sgi.com
	with ESMTP id 63GHTJv4QL0SLyGJ (version=TLSv1 cipher=AES256-SHA
	bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 08 May 2014 01:57:08 -0700 (PDT)
Date: Thu, 8 May 2014 11:05:22 +0200
From: David Disseldorp <ddiss@suse.de>
Subject: Re: [PATCH] btrfs/035: update clone test to expect EOPNOTSUPP
Message-ID: <20140508110522.21930dfd@f163.suse.de>
In-Reply-To: <20140508041123.GB3407@localhost.localdomain>
References: <1399465998-26545-1-git-send-email-ddiss@suse.de>
	<20140508041123.GB3407@localhost.localdomain>
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
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com

Hi liubo,

On Thu, 8 May 2014 12:11:24 +0800, Liu Bo wrote:

> Something different here, I didn't get EIO on 3.15.0-rc4.

Strange, I'm able to consistently reproduce this on a
vanilla v3.15-rc4-202-g30321c7 kernel.
Does that mean the updated test passes successfully for you?

Cheers, David

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
