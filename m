Return-Path: <xfs-bounces@oss.sgi.com>
Received: from relay.sgi.com (relay1.corp.sgi.com [137.38.102.111])
	by oss.sgi.com (Postfix) with ESMTP id 3E4327CAC
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 08:18:43 -0600 (CST)
Received: from cuda.sgi.com (cuda2.sgi.com [192.48.176.25])
	by relay1.corp.sgi.com (Postfix) with ESMTP id 1D7558F8035
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 06:18:42 -0800 (PST)
Received: from sandeen.net (sandeen.net [63.231.237.45]) by cuda.sgi.com with
	ESMTP id sCJNC1c8WBbDIaoc for <xfs@oss.sgi.com>;
	Fri, 12 Feb 2016 06:18:39 -0800 (PST)
Received: from liberator.sandeen.net (liberator.sandeen.net [10.0.0.4])
	(using TLSv1.2 with cipher DHE-RSA-AES128-SHA (128/128 bits))
	(No client certificate requested)
	by sandeen.net (Postfix) with ESMTPSA id 4115B63C5FF0
	for <xfs@oss.sgi.com>; Fri, 12 Feb 2016 08:18:39 -0600 (CST)
Subject: Re: [PATCH 2/2 v3] xfs_repair: new secondary superblock search method
References: <1455130218-8683-1-git-send-email-billodo@redhat.com>
	<56BD2500.4080708@sandeen.net>
From: Eric Sandeen <sandeen@sandeen.net>
Message-ID: <56BDE9BE.9030300@sandeen.net>
Date: Fri, 12 Feb 2016 08:18:38 -0600
MIME-Version: 1.0
In-Reply-To: <56BD2500.4080708@sandeen.net>
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



On 2/11/16 6:19 PM, Eric Sandeen wrote:
> Hi Bill, looks like this is a diff on top of your prior patch,
> not a standalone patch.  It's modifying (not creating) libxcmd/topology.c,
> which doesn't exist upstream yet.

Sorry, I apologize - this was patch 2 of 2, and I didn't have patch 1
applied.  It's easier to spot dependencies when a series stays properly
threaded, though.  :)

And best to not fix issues with patch 1 in patch 2; just fix things
in the original patch which introduced it.

i.e. this:

--- a/libxcmd/topology.c
+++ b/libxcmd/topology.c
@@ -192,7 +192,8 @@ out:
 	return ret;
 }
 
-static void blkid_get_topology(
+static void
+blkid_get_topology(
 	const char	*device,
 	int		*sunit,
 	int		*swidth,
@@ -284,7 +285,8 @@ check_overwrite(
 	return 1;
 }

should all just be formatted as you want it in patch 1.

Thanks,
-Eric

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
