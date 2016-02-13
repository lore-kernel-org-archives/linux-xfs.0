Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id D733F7CA2
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 20:22:26 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id C9F268F8039
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 18:22:23 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id z5pgC89cjBfSvAa1 for <xfs@oss.sgi.com>;
	Fri, 12 Feb 2016 18:22:21 -0800 (PST)
Received: from Liberator.local (24-158-28-51.static.dlth.mn.charter.com
	[24.158.28.51])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id F21D463C5FF0
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 20:22:20 -0600 (CST)
Subject: Re: [PATCH v4 1/2] libxcmd: generalize topology functions
References: <1455303811-9874-1-git-send-email-billodo@redhat.com>
	<1455303811-9874-2-git-send-email-billodo@redhat.com>
	<20160212193942.GA4770@infradead.org>
	<20160212194749.GA10069@redhat.com>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56BE935B.8030501@sandeen.net>
Date: Fri, 12 Feb 2016 20:22:19 -0600
MIME-Version: 1.0
In-Reply-To: <20160212194749.GA10069@redhat.com>
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



On 2/12/16 1:47 PM, Bill O'Donnell wrote:
> On Fri, Feb 12, 2016 at 11:39:42AM -0800, Christoph Hellwig wrote:
>> On Fri, Feb 12, 2016 at 01:03:30PM -0600, Bill O'Donnell wrote:
>>> Move general topology functions from xfs_mkfs to new topology
>>> collection in libxcmd.
>>
>> Why libxcmd and not libxfs?
> 
> We discussed that a bit. Since libxfs has the kernel support code, and
> not generally the xfsprogs library, I put it in libxcmd.

Yep, Dave asked for libxcmd, to keep stuff that's not shared with
the kernel away from libxfs.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
