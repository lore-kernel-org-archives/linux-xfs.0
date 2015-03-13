Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 417BA7F4E
	for <xfs@oss.sgi.com>; Fri, 13 Mar 2015 17:42:49 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id BEC4EAC001
	for <xfs@oss.sgi.com>; Fri, 13 Mar 2015 15:42:45 -0700 (PDT)
Received: from mx1.redhat.com (mx1.redhat.com [209.132.183.28]) by
	cuda.sgi.com with ESMTP id DAGxR1DH2NiIfQj6 (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Fri, 13 Mar 2015 15:42:44 -0700 (PDT)
Message-ID: <550367E2.70605@redhat.com>
Date: Fri, 13 Mar 2015 17:42:42 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
Subject: Re: [PATCH 1/4] xfs_repair: validate & fix inode CRCs
References: <54F77199.8030708@redhat.com> <54F771DE.40107@sandeen.net>
	<20150313132006.GA2678@laptop.bfoster>
In-Reply-To: <20150313132006.GA2678@laptop.bfoster>
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
To: Brian Foster <bfoster@redhat.com>, Eric Sandeen <sandeen@sandeen.net>
Cc: xfs-oss <xfs@oss.sgi.com>

On 3/13/15 8:20 AM, Brian Foster wrote:

...

> What about verify_mode? It should probably report the inode as bunk if
> the crc is bad. Some of the subsequent checks handle this with some
> logic to just return 1 if something is bogus and we're in verify mode.

So, I read through the verify_mode portion on the plane ride back; I think
it's gotten a bit inconsistent over time.  I feel like I understand it a
bit better now, and will send a v3 which matches what I understand to be
its intent, and another patch to document it & make the rest consistent.

Thanks for keeping me honest.  ;)

-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
