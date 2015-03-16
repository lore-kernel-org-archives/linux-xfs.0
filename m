Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 274A17F59
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 09:27:30 -0500 (CDT)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 05BD78F804C
	for <xfs@oss.sgi.com>; Mon, 16 Mar 2015 07:27:26 -0700 (PDT)
Received: from fieldses.org (fieldses.org [173.255.197.46]) by cuda.sgi.com
	with ESMTP id 4ZOtBMhhDwPW8dyp for <xfs@oss.sgi.com>;
	Mon, 16 Mar 2015 07:27:21 -0700 (PDT)
Date: Mon, 16 Mar 2015 10:27:21 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
Subject: Re: panic on 4.20 server exporting xfs filesystem
Message-ID: <20150316142721.GA12231@fieldses.org>
References: <20150303221033.GB19439@fieldses.org>
	<20150315125821.GA10655@lst.de>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <20150315125821.GA10655@lst.de>
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
Cc: linux-nfs@vger.kernel.org, xfs@oss.sgi.com

On Sun, Mar 15, 2015 at 01:58:21PM +0100, Christoph Hellwig wrote:
> On Tue, Mar 03, 2015 at 05:10:33PM -0500, J. Bruce Fields wrote:
> > I'm getting mysterious crashes on a server exporting an xfs filesystem.
> 
> Can you shared the setup used to reproduce the various issues in this thread?

Server and client are both kvm guests.  I'm running xfstests with a
bunch of known-to-fail tests excluded:

	cat >/etc/xfsqa.config <<EOF
	TEST_DIR=/mnt
	TEST_DEV=$server:/exports/xfs2
	NFS_MOUNT_OPTIONS="-overs=4.1"
	EOF
	./check -nfs -g auto -E ~/xfstests-skip

where xfs-tests-skip is:

	generic/003 generic/004 generic/008 generic/009 generic/010
	generic/012 generic/015 generic/016 generic/018 generic/020 generic/021
	generic/022
	generic/024 generic/025 generic/026 generic/027 generic/030 generic/034
	generic/036 generic/038 generic/039 generic/040 generic/041 generic/070
	generic/076 generic/077 generic/079 generic/083 generic/093 generic/097
	generic/099 generic/112 generic/113 generic/123 generic/125 generic/128
	generic/192 generic/193 generic/198 generic/204 generic/207 generic/208
	generic/209 generic/210 generic/211 generic/212 generic/213 generic/214
	generic/219 generic/223 generic/224 generic/226 generic/228 generic/230
	generic/231 generic/232 generic/233 generic/234 generic/235 generic/237
	generic/239 generic/240 generic/241 generic/255 generic/256 generic/260
	generic/269 generic/270 generic/273 generic/274 generic/275 generic/280
	generic/288 generic/299 generic/300 generic/311 generic/312 generic/314
	generic/315 generic/316 generic/317 generic/318 generic/319 generic/320
	generic/321 generic/322 generic/323 generic/324 generic/325 shared/006
	shared/032 shared/051 shared/272 shared/289 shared/298

Kernel is 26cbcc77df, from

	git://linux-nfs.org/~bfields/linux-topics.git for-4.0-incoming

(just upstream 6587457b4b3 plus your fix for layout_fail recursion).

I have another exported xfs filesystem on this server that's on a device
shared with the client, but this filesystem isn't.

Config has basically all the NFS stuff turned on (including NFSD_PNFS).

Gory details in an ugly pile of shell scripts at
git://linux-nfs.org/~bfields/testd.git.

> I've been trying ot get a baseline, but even withotu CONFIG_NFSD_PNFS set
> I start to run into other prolems early on, so I suspect the reproducer might
> be something else?

What other problems?

--b.

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
