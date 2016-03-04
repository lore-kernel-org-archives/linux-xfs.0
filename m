Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay2.corp.sgi.com [137.38.102.29])
	by oss.sgi.com (Postfix) with ESMTP id BAD967CA1
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 06:50:18 -0600 (CST)
Received: from cuda.sgi.com (cuda1.sgi.com [192.48.157.11])
	by relay2.corp.sgi.com (Postfix) with ESMTP id 809E7304048
	for <xfs@oss.sgi.com>; Fri,  4 Mar 2016 04:50:18 -0800 (PST)
Received: from prv-mh.provo.novell.com (prv-mh.provo.novell.com
	[137.65.248.74]) by cuda.sgi.com with ESMTP id 5qzUyU6BkIrM5kCE
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256
	verify=NO) for <xfs@oss.sgi.com>;
	Fri, 04 Mar 2016 04:49:50 -0800 (PST)
Message-Id: <56D9927E02000078000D9696@prv-mh.provo.novell.com>
Date: Fri, 04 Mar 2016 05:49:50 -0700
From: "Jan Beulich" <JBeulich@suse.com>
Subject: Re: [PATCH 4/4] xfs: only run torn log write detection on dirty logs
References: <1457008798-58734-1-git-send-email-bfoster@redhat.com>
	<1457008798-58734-5-git-send-email-bfoster@redhat.com>
In-Reply-To: <1457008798-58734-5-git-send-email-bfoster@redhat.com>
Mime-Version: 1.0
Content-Disposition: inline
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
To: Brian Foster <bfoster@redhat.com>
Cc: xfs@oss.sgi.com

>>> On 03.03.16 at 13:39, <bfoster@redhat.com> wrote:
> XFS uses CRC verification over a sub-range of the head of the log to
> detect and handle torn writes. This torn log write detection currently
> runs unconditionally at mount time, regardless of whether the log is
> dirty or clean. This is problematic in cases where a filesystem might
> end up being moved across different, incompatible (i.e., opposite
> byte-endianness) architectures.
> 
> The problem lies in the fact that log data is not necessarily written in
> an architecture independent format. For example, certain bits of data
> are written in native endian format. Further, the size of certain log
> data structures differs (i.e., struct xlog_rec_header) depending on the
> word size of the cpu. This leads to false positive crc verification
> errors and ultimately failed mounts when a cleanly unmounted filesystem
> is mounted on a system with an incompatible architecture from data that
> was written near the head of the log.
> 
> Update the log head/tail discovery code to run torn write detection only
> when the log is not clean. This means something other than an unmount
> record resides at the head of the log and log recovery is imminent. It
> is a requirement to run log recovery on the same type of host that had
> written the content of the dirty log and therefore CRC failures are
> legitimate corruptions in that scenario.
> 
> Reported-by: Jan Beulich <JBeulich@suse.com>
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Tested-by: Jan Beulich <JBeulich@suse.com>

Thank you Brian.

Jan

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
