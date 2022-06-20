Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D2C6ACCA47C
	for <linux-xfs@archiver.kernel.org>; Mon, 20 Jun 2022 23:08:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346259AbiFTXIR (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Mon, 20 Jun 2022 19:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345673AbiFTXH4 (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Mon, 20 Jun 2022 19:07:56 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D1A7E240A5
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jun 2022 16:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1655766410;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=d+rj3Zp2EbIXr3D0vy6DiaKID1mPHZ0AQJFkTlV285A=;
        b=bnOO7+JhNl9SZ0UE7h84MhxVHiGpsXgvlZKYnMxfUHXwflLRQVuAESXGJQze6Zz9WjOBxI
        DknpY6KcjbbZqS9nz1CcsDCBYvllJlnYtPmWrHXZbyV/9RowkeiScRZjoDQPyEF5xkfXfl
        RDXHt6165uqYPsEWGIePiH3E3N17YKE=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-636-CrtsHOBQOq61p_u39pg1iQ-1; Mon, 20 Jun 2022 19:06:49 -0400
X-MC-Unique: CrtsHOBQOq61p_u39pg1iQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id AC9D4299E760
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jun 2022 23:06:48 +0000 (UTC)
Received: from [127.0.0.1] (b1-int-ext.bast-001.prod.rdu2.dc.redhat.com [10.23.176.77])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8EDF1C28115
        for <linux-xfs@vger.kernel.org>; Mon, 20 Jun 2022 23:06:48 +0000 (UTC)
Message-ID: <9b86c15d-042e-26ed-095c-67910d90ddc6@redhat.com>
Date:   Mon, 20 Jun 2022 18:06:48 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH] xfs: add selinux labels to whiteout inodes
Content-Language: en-US
From:   Eric Sandeen <sandeen@redhat.com>
To:     linux-xfs@vger.kernel.org
References: <1655765731-21078-1-git-send-email-sandeen@redhat.com>
In-Reply-To: <1655765731-21078-1-git-send-email-sandeen@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

I had mentioned this problem in passing to dchinner, and came away with
a vague sense that I might be Doing It Wrong. So I should have labeled
the patch RFC, I suppose.

An easy way to demonstrate the selinux label result is with this test
program, as provided by the bug reporter.  ls -lZ will then show you
the resulting labels on each file.

#define _GNU_SOURCE
#include <sys/mount.h>
#include <sys/stat.h>
#include <errno.h>
#include <fcntl.h>
#include <sched.h>
#include <stdio.h>
#include <unistd.h>
int main(int argc, char **argv) {
	int rc, fd, dirfd;
	rc = mkdir("upper", 0700);
	if ((rc != 0) && (errno != EEXIST)) {
		perror("mkdir");
		return rc;
	}
	rc = unlink("upper/0");
	if ((rc != 0) && (errno != ENOENT)) {
		perror("unlink");
		return rc;
	}
	rc = unlink("upper/empty");
	if ((rc != 0) && (errno != ENOENT)) {
		perror("unlink");
		return rc;
	}
	dirfd = open("upper", O_PATH);
	if (dirfd == -1) {
		perror("open");
		return dirfd;
	}
	fd = creat("upper/empty", 0600);
	if (fd == -1) {
		perror("creat");
		return fd;
	}
	close(fd);
	rc = renameat2(dirfd, "empty", dirfd, "0", RENAME_WHITEOUT);
	if (rc == -1) {
		perror("renameat2");
		return rc;
	}
	close(dirfd);
	return 0;
}

