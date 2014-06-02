Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 2FB8C7F55
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 08:52:37 -0500 (CDT)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1B6E38F8049
	for <xfs@oss.sgi.com>; Mon,  2 Jun 2014 06:52:36 -0700 (PDT)
Received: from relay1.mentorg.com (relay1.mentorg.com [192.94.38.131]) by
	cuda.sgi.com with ESMTP id 87g01MqOrm9NF29P (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Mon, 02 Jun 2014 06:52:35 -0700 (PDT)
Date: Mon, 2 Jun 2014 13:52:19 +0000
From: "Joseph S. Myers" <joseph@codesourcery.com>
Subject: Re: [RFC 00/32] making inode time stamps y2038 ready
In-Reply-To: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
Message-ID: <Pine.LNX.4.64.1406021350030.19591@digraph.polyomino.org.uk>
References: <1401480116-1973111-1-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
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
To: Arnd Bergmann <arnd@arndb.de>
Cc: hch@infradead.org, linux-mtd@lists.infradead.org, hpa@zytor.com, logfs@logfs.org, linux-afs@lists.infradead.org, linux-arch@vger.kernel.org, linux-cifs@vger.kernel.org, linux-scsi@vger.kernel.org, ceph-devel@vger.kernel.org, codalist@coda.cs.cmu.edu, cluster-devel@redhat.com, coda@cs.cmu.edu, geert@linux-m68k.org, linux-ext4@vger.kernel.org, fuse-devel@lists.sourceforge.net, reiserfs-devel@vger.kernel.org, xfs@oss.sgi.com, john.stultz@linaro.org, tglx@linutronix.de, linux-nfs@vger.kernel.org, linux-ntfs-dev@lists.sourceforge.net, samba-technical@lists.samba.org, linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, lftan@altera.com, linux-btrfs@vger.kernel.org

On Fri, 30 May 2014, Arnd Bergmann wrote:

> a) is this the right approach in general? The previous discussion
>    pointed this way, but there may be other opinions.

The syscall changes seem like the sort of thing I'd expect, although 
patches adding new syscalls or otherwise affecting the kernel/userspace 
interface (as opposed to those relating to an individual filesystem) 
should go to linux-api as well as other relevant lists.

-- 
Joseph S. Myers
joseph@codesourcery.com

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
