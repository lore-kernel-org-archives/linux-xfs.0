Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id 527127F51
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 12:24:55 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 4CB06304062
	for <xfs@oss.sgi.com>; Fri,  9 May 2014 10:24:52 -0700 (PDT)
Received: from mx0b-00082601.pphosted.com (mx0b-00082601.pphosted.com
	[67.231.153.30]) by cuda.sgi.com with ESMTP id 80nfOGWsqExpPsv8
	for <xfs@oss.sgi.com>; Fri, 09 May 2014 10:24:48 -0700 (PDT)
Message-ID: <536D0F56.8040604@fb.com>
Date: Fri, 9 May 2014 13:24:38 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
Subject: Re: [PATCH v2 1/3] xfstests/btrfs: add qgroup rescan stress test
References: <1394423051-17356-1-git-send-email-wangsl.fnst@cn.fujitsu.com>
	<536A9E73.90802@fb.com> <536AFC3B.7070502@cn.fujitsu.com>
	<536BCDF7.7070404@fb.com>, <536C2C99.6020506@cn.fujitsu.com>
	<xmifb9cukl6cxjty7n8malrf.1399601580721@email.android.com>
	<536C40E7.5090502@cn.fujitsu.com>
In-Reply-To: <536C40E7.5090502@cn.fujitsu.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>

On 05/08/2014 10:43 PM, Wang Shilong wrote:
> On 05/09/2014 10:13 AM, Josef Bacik wrote:
>> The inode cache is saved in the FS tree itself for every individual FS
>> tree, that affects the sizes reported by qgroup show so we need to
>> explicitly turn it off to get consistent values.  Thanks,
> Right, so we need turn off inode_cache explicitly rather than free_space
> option.
> I will fix all your addressed comments and resend the patch.
>

Sigh I totally said nospace_cache didn't I?  I really meant 
noinode_cache, sorry,

Josef

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
