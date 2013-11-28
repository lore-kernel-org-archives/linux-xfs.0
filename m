Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 4D7E97F51
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 04:50:41 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 3816F8F8065
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 02:50:41 -0800 (PST)
Received: from mail-oa0-f44.google.com (mail-oa0-f44.google.com
	[209.85.219.44]) by cuda.sgi.com with ESMTP id qpHZZMZmyJgauC5V
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Thu, 28 Nov 2013 02:50:40 -0800 (PST)
Received: by mail-oa0-f44.google.com with SMTP id m1so9037203oag.3
	for <xfs@oss.sgi.com>; Thu, 28 Nov 2013 02:50:40 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131128103549.GA26927@infradead.org>
References: <1385379154-3802-1-git-send-email-zwu.kernel@gmail.com>
	<20131128103549.GA26927@infradead.org>
Date: Thu, 28 Nov 2013 18:50:39 +0800
Message-ID: <CAEH94LhyKoOhaUG1ToomqT_LnxG1rxcTJ2WK3D2N_Eu7pgKQhQ@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] xfs: add O_TMPFILE support
From: Zhi Yong Wu <zwu.kernel@gmail.com>
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
To: Christoph Hellwig <hch@infradead.org>
Cc: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, xfstests <xfs@oss.sgi.com>

On Thu, Nov 28, 2013 at 6:35 PM, Christoph Hellwig <hch@infradead.org> wrote:
> On Mon, Nov 25, 2013 at 07:32:30PM +0800, Zhi Yong Wu wrote:
>> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
>>
>> HI, folks
>>
>> The patchset is trying to add O_TMPFILE support to xfs. To make sure
>> that it is going ahead in the right direction, although it is only one
>> code draft, and hasn't strictly been tested, it is still post out ASAP.
>
> Btw, for the real submission we need proper xfstests coverage, I can't
ok, i will try to run xfstests before real submission is done.
> really believe how the other filesystems added it without QA coverage :(
heh, i guess that you should ask those fs maintainers this question.
>
> Besides the obvious test programs there's a reproducer for a a simple
> bug already in commit dda5690defe4af62ee120f055e98e40d97e4c760 in the
> kernel tree.
ok, will test if this bug is triggered.
>



-- 
Regards,

Zhi Yong Wu

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
