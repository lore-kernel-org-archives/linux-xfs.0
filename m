Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 7AF627FB3
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 17:56:00 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 5536C8F8052
	for <xfs@oss.sgi.com>; Fri,  1 Mar 2013 15:56:00 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id brBq3HIFXnKh1Xib for <xfs@oss.sgi.com>;
	Fri, 01 Mar 2013 15:55:59 -0800 (PST)
Message-ID: <5131400E.5060207@sandeen.net>
Date: Fri, 01 Mar 2013 17:55:58 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
Subject: Re: xfs_repair segfaults
References: <CANU9nTnvJS50vdQv2K0gKHZPvzzH5EY1qpizJNsqUobrr2juDA@mail.gmail.com>
	<5131283F.8030704@sandeen.net> <20130301223116.GE23616@dastard>
	<51312C73.5060203@sandeen.net>
In-Reply-To: <51312C73.5060203@sandeen.net>
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
To: Dave Chinner <david@fromorbit.com>
Cc: Ole Tange <tange@binf.ku.dk>, xfs@oss.sgi.com

On 3/1/13 4:32 PM, Eric Sandeen wrote:
> Ole, you can xfs_mdrestore your metadump image and run test repairs on the result,

If you like, test it after applying the patch I just sent.

(or wait 'til it's reviewed) :)

Anyway, running in non "-n" mode will avoid the segfault you
reported.

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
