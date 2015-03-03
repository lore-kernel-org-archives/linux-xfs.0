Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id CD7987F47
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 17:31:18 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 6A059AC001
	for <xfs@oss.sgi.com>; Tue,  3 Mar 2015 15:31:18 -0800 (PST)
Received: from ipmail06.adl6.internode.on.net (ipmail06.adl6.internode.on.net
	[150.101.137.145]) by cuda.sgi.com with ESMTP id
	raL16jt4Qg7MCGjg for <xfs@oss.sgi.com>;
	Tue, 03 Mar 2015 15:31:13 -0800 (PST)
From: Dave Chinner <david@fromorbit.com>
Subject: [RFC PATCH 0/6] xfs: DAX support
Date: Wed,  4 Mar 2015 10:30:21 +1100
Message-Id: <1425425427-16283-1-git-send-email-david@fromorbit.com>
List-Id: XFS Filesystem from SGI <xfs.oss.sgi.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/options/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: xfs-bounces@oss.sgi.com
Sender: xfs-bounces@oss.sgi.com
To: xfs@oss.sgi.com
Cc: linux-fsdevel@vger.kernel.org, willy@linux.intel.com, jack@suse.cz

Hi folks,

This is the first pass I've made for supporting DAX in XFS. Most
of the XFS changes are straight forward and fairly self contained,
and mostly seem to work.

The first patch, however, is changing the DAX infrastructure to take
a "block zeroing completion" function for dax_fault() so that we
don't need to abuse the mapping bufferhead to pass the completion
function. This is straight forward for XFS, but the ext4 code is,
well, it's already broken so I don't think I've made anything worse.

I note that Jan Kara is aware of the problems related to the
unwritten extent conversion in ext4, as mentioned here earlier
today on the ext4 list (items 1 and 2):

http://permalink.gmane.org/gmane.comp.file-systems.ext4/47943

So really my only concern here is cleaning up the interface to
remove the mapping bh hack, not whether ext4 works reliably or not.
The XFS implementation does not have any of the problems the ext4
code does.

The rest of the series adds all the DAX hooks into the required code
paths for block zeroing, page fault, io, truncate and finally the
mount path for the dax mount option.

The series passes xfstests without and serious problems - there are
a couple of tests where the extent layout isn't as the tests expect,
but these are minor issues that don't affect correctness.

Comments welcome, especially on the this dax_fault callback patch.

-Dave.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
