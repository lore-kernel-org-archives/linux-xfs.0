Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay3.corp.sgi.com [198.149.34.15])
	by oss.sgi.com (Postfix) with ESMTP id 0309C7F8D
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 05:11:25 -0600 (CST)
Received: from cuda.sgi.com (cuda3.sgi.com [192.48.176.15])
	by relay3.corp.sgi.com (Postfix) with ESMTP id 74923AC00A
	for <xfs@oss.sgi.com>; Thu, 22 Jan 2015 03:11:24 -0800 (PST)
Received: from casper.infradead.org (casper.infradead.org [85.118.1.10]) by
	cuda.sgi.com with ESMTP id gFNa7dDQE4eTF3nV (version=TLSv1
	cipher=AES256-SHA bits=256 verify=NO) for <xfs@oss.sgi.com>;
	Thu, 22 Jan 2015 03:11:22 -0800 (PST)
From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 12/20] nfsd: update documentation for pNFS support
Date: Thu, 22 Jan 2015 12:09:58 +0100
Message-Id: <1421925006-24231-13-git-send-email-hch@lst.de>
In-Reply-To: <1421925006-24231-1-git-send-email-hch@lst.de>
References: <1421925006-24231-1-git-send-email-hch@lst.de>
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
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Jeff Layton <jlayton@primarydata.com>, xfs@oss.sgi.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/filesystems/nfs/nfs41-server.txt | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/Documentation/filesystems/nfs/nfs41-server.txt b/Documentation/filesystems/nfs/nfs41-server.txt
index c49cd7e..682a59f 100644
--- a/Documentation/filesystems/nfs/nfs41-server.txt
+++ b/Documentation/filesystems/nfs/nfs41-server.txt
@@ -24,11 +24,6 @@ focuses on the mandatory-to-implement NFSv4.1 Sessions, providing
 "exactly once" semantics and better control and throttling of the
 resources allocated for each client.
 
-Other NFSv4.1 features, Parallel NFS operations in particular,
-are still under development out of tree.
-See http://wiki.linux-nfs.org/wiki/index.php/PNFS_prototype_design
-for more information.
-
 The table below, taken from the NFSv4.1 document, lists
 the operations that are mandatory to implement (REQ), optional
 (OPT), and NFSv4.0 operations that are required not to implement (MNI)
@@ -43,9 +38,7 @@ The OPTIONAL features identified and their abbreviations are as follows:
 The following abbreviations indicate the linux server implementation status.
 	I	Implemented NFSv4.1 operations.
 	NS	Not Supported.
-	NS*	unimplemented optional feature.
-	P	pNFS features implemented out of tree.
-	PNS	pNFS features that are not supported yet (out of tree).
+	NS*	Unimplemented optional feature.
 
 Operations
 
@@ -70,13 +63,13 @@ I  | DESTROY_SESSION      | REQ        |              | Section 18.37  |
 I  | EXCHANGE_ID          | REQ        |              | Section 18.35  |
 I  | FREE_STATEID         | REQ        |              | Section 18.38  |
    | GETATTR              | REQ        |              | Section 18.7   |
-P  | GETDEVICEINFO        | OPT        | pNFS (REQ)   | Section 18.40  |
-P  | GETDEVICELIST        | OPT        | pNFS (OPT)   | Section 18.41  |
+I  | GETDEVICEINFO        | OPT        | pNFS (REQ)   | Section 18.40  |
+NS*| GETDEVICELIST        | OPT        | pNFS (OPT)   | Section 18.41  |
    | GETFH                | REQ        |              | Section 18.8   |
 NS*| GET_DIR_DELEGATION   | OPT        | DDELG (REQ)  | Section 18.39  |
-P  | LAYOUTCOMMIT         | OPT        | pNFS (REQ)   | Section 18.42  |
-P  | LAYOUTGET            | OPT        | pNFS (REQ)   | Section 18.43  |
-P  | LAYOUTRETURN         | OPT        | pNFS (REQ)   | Section 18.44  |
+I  | LAYOUTCOMMIT         | OPT        | pNFS (REQ)   | Section 18.42  |
+I  | LAYOUTGET            | OPT        | pNFS (REQ)   | Section 18.43  |
+I  | LAYOUTRETURN         | OPT        | pNFS (REQ)   | Section 18.44  |
    | LINK                 | OPT        |              | Section 18.9   |
    | LOCK                 | REQ        |              | Section 18.10  |
    | LOCKT                | REQ        |              | Section 18.11  |
@@ -122,9 +115,9 @@ Callback Operations
    |                         | MNI       | or OPT)     |               |
    +-------------------------+-----------+-------------+---------------+
    | CB_GETATTR              | OPT       | FDELG (REQ) | Section 20.1  |
-P  | CB_LAYOUTRECALL         | OPT       | pNFS (REQ)  | Section 20.3  |
+I  | CB_LAYOUTRECALL         | OPT       | pNFS (REQ)  | Section 20.3  |
 NS*| CB_NOTIFY               | OPT       | DDELG (REQ) | Section 20.4  |
-P  | CB_NOTIFY_DEVICEID      | OPT       | pNFS (OPT)  | Section 20.12 |
+NS*| CB_NOTIFY_DEVICEID      | OPT       | pNFS (OPT)  | Section 20.12 |
 NS*| CB_NOTIFY_LOCK          | OPT       |             | Section 20.11 |
 NS*| CB_PUSH_DELEG           | OPT       | FDELG (OPT) | Section 20.5  |
    | CB_RECALL               | OPT       | FDELG,      | Section 20.2  |
-- 
1.9.1

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
