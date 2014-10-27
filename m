Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 043C47F56
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 08:25:29 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id D75408F8035
	for <xfs@oss.sgi.com>; Mon, 27 Oct 2014 06:25:25 -0700 (PDT)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id 5uzmQjEBoAlLL1PT for <xfs@oss.sgi.com>;
	Mon, 27 Oct 2014 06:25:23 -0700 (PDT)
Message-ID: <544E47C1.5070906@sandeen.net>
Date: Mon, 27 Oct 2014 08:25:21 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: [PATCH] xfsprogs: enable sparse checking
References: <54498F4A.9030207@redhat.com>
	<20141024061718.GA15341@infradead.org>
	<544A59F7.4070601@sandeen.net>
	<20141024154058.GA10788@infradead.org>
	<544A74E7.1060502@sandeen.net>
	<20141027094800.GB31604@infradead.org>
In-Reply-To: <20141027094800.GB31604@infradead.org>
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
Cc: Eric Sandeen <sandeen@redhat.com>, xfs-oss <xfs@oss.sgi.com>

On 10/27/14 4:48 AM, Christoph Hellwig wrote:
> On Fri, Oct 24, 2014 at 10:48:55AM -0500, Eric Sandeen wrote:
>> On 10/24/14 10:40 AM, Christoph Hellwig wrote:
>>> strong opinion.  It's not like your patch prevents me from using CC=cgcc
>>
>> To get endian checking with your method, you'd need to edit
>> the Makefile to add the -D define, right?
> 
> That's a kernel special, I just did a test run using CC=cgcc and I get
> endianess warnings:
> 
> rdwr.c:190:21: warning: incorrect type in assignment (different base types)
> rdwr.c:190:21:    expected restricted __le32 [usertype] h_crc
> rdwr.c:190:21:    got restricted __be32 [usertype] <noident>

Oh, without an extra define?  Hrm.  Ok I guess I need to read
up on what enables it.

I did send a couple patches to fix some of these.  Sorry, didn't
do it in a series:

[PATCH] xfsprogs: fix endian mishap in xfs_dialloc_ag()
[PATCH] xfsprogs: fix harmless sparse endian nit

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
