Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BAA1B86E9
	for <linux-xfs@vger.kernel.org>; Tue,  9 Jul 2024 19:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720552235; cv=none; b=V/DbkSI11gSrSTOspzGMd9nCBREQ6DU8FXyFZehsaCn8e3cjT3NMETl2YSQcrEaTQMRy+TYsSUhcZ2HwnKxgxV37LNC5zz75xNMihvhjOUJwDGppur+FuwO3Tg9ra3KWvDlXLuKKrj84QGUamJS/Ldq6ob30IEKA2SxajPb/Flc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720552235; c=relaxed/simple;
	bh=SY4A9Knxc2XnmFXsoGQ9R9tpa1lrf3jTtT4El+T38MA=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type; b=uj47zUj47HdJMOnPuk9lfIPLCqwLXotVfCmAJCDH3HYplG1DfUYcIUu7ZGQtbU/Pr2ua//i7KFaC/eN9z1TP+XQwm9htBVsBoPwM3zf2XSIyq90UvugkEvlAmgGmrRHA9O0Q6HQdZwOIzUUdUOg4Tj1sEeCqftfsbNqmoz0gEmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=o2xb72xc; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="o2xb72xc"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 469FtaRH014970
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:mime-version:content-type
	:content-transfer-encoding; s=corp-2023-11-20; bh=CZ9l0LJfZbtFVY
	UtJ8UCYeNOvbELxitKwbiMz85m2Xw=; b=o2xb72xcfWCZB/HCZFBZsiQ/IJsZNg
	G5CG26ElMI8jIDAn/3DOEq3S1dco/qQl8zBPdzMgzW3HY9srxTCT/1I5q/TXzCAP
	mzvA1Oxw0AHYHizbp8Baj2Om+Kcewn5HMCAb+iNP816PzhCUdARViLu9TlIHFWiU
	Fn1s5XE90OEQOxFx0t39zEhkXHwHgWbyLUgu8areouA4ZebEaEn3ZMzQSOkRuWj/
	SaYzegLHTi/XKkrLt+eyg7ktlTKgfzJ16XPqKeXITv7rcXqsHblcrBhcPE5MCKX9
	rfl5Rfv4AMzOVtPlh17ITiBS27r1lFZF7145IZJbUW4seBhu2oG7J1gg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 406wt8dq2d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 19:10:32 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 469HlYDb013579
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 407txhepma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-xfs@vger.kernel.org>; Tue, 09 Jul 2024 19:10:30 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 469JAUPO024440
	for <linux-xfs@vger.kernel.org>; Tue, 9 Jul 2024 19:10:30 GMT
Received: from wwg-mac.us.oracle.com (dhcp-10-159-146-188.vpn.oracle.com [10.159.146.188])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 407txhepkm-1;
	Tue, 09 Jul 2024 19:10:30 +0000
From: Wengang Wang <wen.gang.wang@oracle.com>
To: linux-xfs@vger.kernel.org
Cc: wen.gang.wang@oracle.com
Subject: [PATCH 0/9] introduce defrag to xfs_spaceman
Date: Tue,  9 Jul 2024 12:10:19 -0700
Message-Id: <20240709191028.2329-1-wen.gang.wang@oracle.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
Precedence: bulk
X-Mailing-List: linux-xfs@vger.kernel.org
List-Id: <linux-xfs.vger.kernel.org>
List-Subscribe: <mailto:linux-xfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-xfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-09_08,2024-07-09_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2406180000 definitions=main-2407090129
X-Proofpoint-GUID: bQkLHe5f1KIS_cgJHYn3YojYkocq0E14
X-Proofpoint-ORIG-GUID: bQkLHe5f1KIS_cgJHYn3YojYkocq0E14

This patch set introduces defrag to xfs_spaceman command. It has the functionality and
features below (also subject to be added to man page, so please review):

       defrag [-f free_space] [-i idle_time] [-s segment_size] [-n] [-a]
              defrag defragments the specified XFS file online non-exclusively. The target XFS
              doesn't have to (and must not) be unmunted.  When defragmentation is in progress, file
              IOs are served 'in parallel'.  reflink feature must be enabled in the XFS.

              Defragmentation and file IOs

              The target file is virtually devided into many small segments. Segments are the
              smallest units for defragmentation. Each segment is defragmented one by one in a
              lock->defragment->unlock->idle manner. File IOs are blocked when the target file is
              locked and are served during the defragmentation idle time (file is unlocked). Though
              the file IOs can't really go in parallel, they are not blocked long. The locking time
              basically depends on the segment size. Smaller segments usually take less locking time
              and thus IOs are blocked shorterly, bigger segments usually need more locking time and
              IOs are blocked longer. Check -s and -i options to balance the defragmentation and IO
              service.

              Temporary file

              A temporary file is used for the defragmentation. The temporary file is created in the
              same directory as the target file is and is named ".xfsdefrag_<pid>". It is a sparse
              file and contains a defragmentation segment at a time. The temporary file is removed
              automatically when defragmentation is done or is cancelled by ctrl-c. It remains in
              case kernel crashes when defragmentation is going on. In that case, the temporary file
              has to be removed manaully.

              Free blocks consumption

              Defragmenation works by (trying) allocating new (contiguous) blocks, copying data and
              then freeing old (non-contig) blocks. Usually the number of old blocks to free equals
              to the number the newly allocated blocks. As a finally result, defragmentation doesn't
              consume free blocks. Well, that is true if the target file is not sharing blocks with
              other files.  In case the target file contains shared blocks, those shared blocks won't
              be freed back to filesystem as they are still owned by other files. So defragmenation
              allocates more blocks than it frees.  For existing XFS, free blocks might be over-
              committed when reflink snapshots were created. To avoid causing the XFS running into
              low free blocks state, this defragmentation excludes (partially) shared segments when
              the file system free blocks reaches a shreshold. Check the -f option.

              Safty and consistency

              The defragmentation file is guanrantted safe and data consistent for ctrl-c and kernel
              crash.

              First extent share

              Current kernel has routine for each segment defragmentation detecting if the file is
              sharing blocks. It takes long in case the target file contains huge number of extents
              and the shared ones, if there is, are at the end. The First extent share feature works
              around above issue by making the first serveral blocks shared. Seeing the first blocks
              are shared, the kernel routine ends quickly. The side effect is that the "share" flag
              would remain traget file. This feature is enabled by default and can be disabled by -n
              option.

              extsize and cowextsize

              According to kernel implementation, extsize and cowextsize could have following impacts
              to defragmentation: 1) non-zero extsize causes separated block allocations for each
              extent in the segment and those blocks are not contiguous. The segment remains same
              number of extents after defragmention (no effect).  2) When extsize and/or cowextsize
              are too big, a lot of pre-allocated blocks remain in memory for a while. When new IO
              comes to whose pre-allocated blocks  Copy on Write happens and causes the file
              fragmented.

              Readahead

              Readahead tries to fetch the data blocks for next segment with less locking in
              backgroud during idle time. This feature is disabled by default, use -a to enable it.

              The command takes the following options:
                 -f free_space
                     The shreshold of XFS free blocks in MiB. When free blocks are less than this
                     number, (partially) shared segments are excluded from defragmentation. Default
                     number is 1024

                 -i idle_time
                     The time in milliseconds, defragmentation enters idle state for this long after
                     defragmenting a segment and before handing the next. Default number is TOBEDONE.

                 -s segment_size
                     The size limitation in bytes of segments. Minimium number is 4MiB, default
                     number is 16MiB.

                 -n  Disable the First extent share feature. Enabled by default.

                 -a  Enable readahead feature, disabled by default.

We tested with real customer metadump with some different 'idle_time's and found 250ms is good pratice
sleep time. Here comes some number of the test:

Test: running of defrag on the image file which is used for the back end of a block device in a
      virtual machine. At the same time, fio is running at the same time inside virtual machine
      on that block device.
block device type:   NVME
File size:           200GiB
paramters to defrag: free_space: 1024 idle_time: 250 First_extent_share: enabled readahead: disabled
Defrag run time:     223 minutes
Number of extents:   6745489(before) -> 203571(after)
Fio read latency:    15.72ms(without defrag) -> 14.53ms(during defrag)
Fio write latency:   32.21ms(without defrag) -> 20.03ms(during defrag)


Wengang Wang (9):
  xfsprogs: introduce defrag command to spaceman
  spaceman/defrag: pick up segments from target file
  spaceman/defrag: defrag segments
  spaceman/defrag: ctrl-c handler
  spaceman/defrag: exclude shared segments on low free space
  spaceman/defrag: workaround kernel xfs_reflink_try_clear_inode_flag()
  spaceman/defrag: sleeps between segments
  spaceman/defrag: readahead for better performance
  spaceman/defrag: warn on extsize

 spaceman/Makefile |   2 +-
 spaceman/defrag.c | 788 ++++++++++++++++++++++++++++++++++++++++++++++
 spaceman/init.c   |   1 +
 spaceman/space.h  |   1 +
 4 files changed, 791 insertions(+), 1 deletion(-)
 create mode 100644 spaceman/defrag.c

-- 
2.39.3 (Apple Git-146)

