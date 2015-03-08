Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2440B7F5F
	for <xfs@oss.sgi.com>; Sun,  8 Mar 2015 08:09:09 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 121EC8F8037
	for <xfs@oss.sgi.com>; Sun,  8 Mar 2015 06:09:05 -0700 (PDT)
Received: from mail-pa0-f44.google.com (mail-pa0-f44.google.com
	[209.85.220.44]) by cuda.sgi.com with ESMTP id bllIguz9iRNvZwl0
	(version=TLSv1 cipher=RC4-SHA bits=128 verify=NO) for
	<xfs@oss.sgi.com>; Sun, 08 Mar 2015 06:09:01 -0700 (PDT)
Received: by pabrd3 with SMTP id rd3so41491433pab.5
	for <xfs@oss.sgi.com>; Sun, 08 Mar 2015 06:09:00 -0700 (PDT)
References: <20150303221033.GB19439@fieldses.org>
	<20150303224456.GV4251@dastard>
	<20150304020826.GD19439@fieldses.org>
	<20150304044141.GQ18360@dastard> <20150305131901.GB16235@lst.de>
Mime-Version: 1.0 (1.0)
In-Reply-To: <20150305131901.GB16235@lst.de>
Message-Id: <07736642-EBA0-4F6B-B6BD-C7C5725A2DC6@primarydata.com>
From: Tom Haynes <thomas.haynes@primarydata.com>
Subject: Re: panic on 4.20 server exporting xfs filesystem
Date: Sun, 8 Mar 2015 06:08:57 -0700
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
To: Christoph Hellwig <hch@lst.de>
Cc: "J. Bruce Fields" <bfields@fieldses.org>, "linux-nfs@vger.kernel.org" <linux-nfs@vger.kernel.org>, "xfs@oss.sgi.com" <xfs@oss.sgi.com>




> On Mar 5, 2015, at 5:19 AM, Christoph Hellwig <hch@lst.de> wrote:
> 
>> On Wed, Mar 04, 2015 at 03:41:41PM +1100, Dave Chinner wrote:
>> As I understand it, nothing will prevent this - if you don't change
>> the UUID on the filesystem when you clone it, then the UUID will
>> still match and writes can be directed to any block deice with a
>> matching offset/UUID pair.
> 
> Unfortunately that's the case indeed.  The whole discovery part of
> the block layout protocol is fundamentally flawed, as is the recall
> part.  This is my attempt to fix it, but I have no idea how to proceed
> from posting my draft to the IETF to actually making it a standard:
> 
> http://tools.ietf.org/html/draft-hellwig-nfsv4-scsi-layout-00

Let's be sure to talk about this at LSF...

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
