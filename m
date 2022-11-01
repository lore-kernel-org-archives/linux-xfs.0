Return-Path: <linux-xfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14EF5FA373D
	for <linux-xfs@archiver.kernel.org>; Tue,  1 Nov 2022 06:19:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiKAGTO (ORCPT <rfc822;linux-xfs@archiver.kernel.org>);
        Tue, 1 Nov 2022 02:19:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbiKAGTM (ORCPT
        <rfc822;linux-xfs@vger.kernel.org>); Tue, 1 Nov 2022 02:19:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0708C11A2F
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 23:18:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667283499;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ReNAaNCvttNfJJU14NWwmyF9zTKUt1F4dPQJzXRY2bY=;
        b=R28vhhTpoEtYIuqyYvO9BlCBEBdDP5cWVZJAuDptKwFlYdNmfU+WunRWUtWVou2wM5jN0l
        Fgc1qQdtSi4hH1e1Iglcr5Q7puR2KiasdFEkaB4CzmIGU6Qthf8eoN21ghxiBPYinBlc+n
        P91xIQ2ubAoPL8v/rAr+rqU4N89baEQ=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-508-9-F7shhHNkm0hgKJPBLgZw-1; Tue, 01 Nov 2022 02:18:18 -0400
X-MC-Unique: 9-F7shhHNkm0hgKJPBLgZw-1
Received: by mail-qt1-f198.google.com with SMTP id fb5-20020a05622a480500b003a525d52abcso3324985qtb.10
        for <linux-xfs@vger.kernel.org>; Mon, 31 Oct 2022 23:18:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ReNAaNCvttNfJJU14NWwmyF9zTKUt1F4dPQJzXRY2bY=;
        b=AwNc3/ctt+5Go2pFPSwW+Cp1ErwECgXosHYS2gUqZFOnOtbJGLtByDEf9K3xh1Ty8K
         zEHzsWhqVu4dbJO6Yxmhb2eEqYIupeIqF+MGx4VtJTJHJ+nwzJUrkKWb9NnKk+SBznAT
         MgOzhLwgmqQtYZbiJ9X4EqZlsteiKqqf2axxgDoLQ1X2+mnC+FHk/6vjSXlhvEwZ4KYp
         k1NgQgCGNHsyzlP59gF2l5rfCloYYqLp2e6PnjNACh/F9lOZ81gKGbJhYzLcC/VNTkw+
         PfjYjnVqeWp7489nWKL3xL4rFjpYj7QIGEwFBQLp4vEZtIdqBa8xlotLbgHC4h46HX6d
         EBxg==
X-Gm-Message-State: ACrzQf36jjDJs6wkqXhBkW81YmaNFJVPYx8sKkeRiz2VngtqCkFgHFrN
        SphMzfJwsiGw0jGktmIdlths1NFH0a2c0c/Ug96Q+ZtdtplR7E8Ekg51lMuZQV1pA+2sn+jriz5
        Da/IXAQ6mVqxps+f09/WI
X-Received: by 2002:ac8:5aca:0:b0:3a5:73a:1aa5 with SMTP id d10-20020ac85aca000000b003a5073a1aa5mr13676609qtd.579.1667283496785;
        Mon, 31 Oct 2022 23:18:16 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5j14dtqgjcciUgvd29cEyPkRdKRVXzLF4sZpvYZBeJymvVebiCYeAi4oP4pmnMnaGF8gNvvA==
X-Received: by 2002:ac8:5aca:0:b0:3a5:73a:1aa5 with SMTP id d10-20020ac85aca000000b003a5073a1aa5mr13676597qtd.579.1667283496492;
        Mon, 31 Oct 2022 23:18:16 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id w29-20020a05620a0e9d00b006fa4cac54a5sm80518qkm.72.2022.10.31.23.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Oct 2022 23:18:15 -0700 (PDT)
Date:   Tue, 1 Nov 2022 14:18:11 +0800
From:   Zorro Lang <zlang@redhat.com>
To:     Catherine Hoang <catherine.hoang@oracle.com>
Cc:     linux-xfs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH v3 1/4] common: add helpers for parent pointer tests
Message-ID: <20221101061811.l3v7dko5kg5x4jbk@zlang-mailbox>
References: <20221028215605.17973-1-catherine.hoang@oracle.com>
 <20221028215605.17973-2-catherine.hoang@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221028215605.17973-2-catherine.hoang@oracle.com>
Precedence: bulk
List-ID: <linux-xfs.vger.kernel.org>
X-Mailing-List: linux-xfs@vger.kernel.org

On Fri, Oct 28, 2022 at 02:56:02PM -0700, Catherine Hoang wrote:
> From: Allison Henderson <allison.henderson@oracle.com>
> 
> Add helper functions in common/parent to parse and verify parent
> pointers. Also add functions to check that mkfs, kernel, and xfs_io
> support parent pointers.
> 
> Signed-off-by: Allison Henderson <allison.henderson@oracle.com>
> Signed-off-by: Catherine Hoang <catherine.hoang@oracle.com>
> ---

Looks good to me, just a few typo problem as below ...

>  common/parent | 198 ++++++++++++++++++++++++++++++++++++++++++++++++++
>  common/rc     |   3 +
>  common/xfs    |  12 +++
>  3 files changed, 213 insertions(+)
>  create mode 100644 common/parent
> 
> diff --git a/common/parent b/common/parent
> new file mode 100644
> index 00000000..a0ba7d92
> --- /dev/null
> +++ b/common/parent
> @@ -0,0 +1,198 @@
> +#
> +# Parent pointer common functions
> +#
> +
> +#
> +# parse_parent_pointer parents parent_inode parent_pointer_name
> +#
> +# Given a list of parent pointers, find the record that matches
> +# the given inode and filename
> +#
> +# inputs:
> +# parents	: A list of parent pointers in the format of:
> +#		  inode/generation/name_length/name
> +# parent_inode	: The parent inode to search for
> +# parent_name	: The parent name to search for
> +#
> +# outputs:
> +# PPINO         : Parent pointer inode
> +# PPGEN         : Parent pointer generation
> +# PPNAME        : Parent pointer name
> +# PPNAME_LEN    : Parent pointer name length
> +#
> +_parse_parent_pointer()
> +{
> +	local parents=$1
> +	local pino=$2
> +	local parent_pointer_name=$3
> +
> +	local found=0
> +
> +	# Find the entry that has the same inode as the parent
> +	# and parse out the entry info
> +	while IFS=\/ read PPINO PPGEN PPNAME_LEN PPNAME; do
> +		if [ "$PPINO" != "$pino" ]; then
> +			continue
> +		fi
> +
> +		if [ "$PPNAME" != "$parent_pointer_name" ]; then
> +			continue
> +		fi
> +
> +		found=1
> +		break
> +	done <<< $(echo "$parents")
> +
> +	# Check to see if we found anything
> +	# We do not fail the test because we also use this
> +	# routine to verify when parent pointers should
> +	# be removed or updated  (ie a rename or a move
> +	# operation changes your parent pointer)
> +	if [ $found -eq "0" ]; then
> +		return 1
> +	fi
> +
> +	# Verify the parent pointer name length is correct
> +	if [ "$PPNAME_LEN" -ne "${#parent_pointer_name}" ]
> +	then
> +		echo "*** Bad parent pointer:"\
> +			"name:$PPNAME, namelen:$PPNAME_LEN"
> +	fi
> +
> +	#return sucess
> +	return 0
> +}
> +
> +#
> +# _verify_parent parent_path parent_pointer_name child_path
> +#
> +# Verify that the given child path lists the given parent as a parent pointer
> +# and that the parent pointer name matches the given name
> +#
> +# Examples:
> +#
> +# #simple example
> +# mkdir testfolder1
> +# touch testfolder1/file1
> +# verify_parent testfolder1 file1 testfolder1/file1

_verify_parent

> +#
> +# # In this above example, we want to verify that "testfolder1"
> +# # appears as a parent pointer of "testfolder1/file1".  Additionally
> +# # we verify that the name record of the parent pointer is "file1"
> +#
> +#
> +# #hardlink example
> +# mkdir testfolder1
> +# mkdir testfolder2
> +# touch testfolder1/file1
> +# ln testfolder1/file1 testfolder2/file1_ln
> +# verify_parent testfolder2 file1_ln testfolder1/file1

_verify_parent

> +#
> +# # In this above example, we want to verify that "testfolder2"
> +# # appears as a parent pointer of "testfolder1/file1".  Additionally
> +# # we verify that the name record of the parent pointer is "file1_ln"
> +#
> +_verify_parent()
> +{
> +	local parent_path=$1
> +	local parent_pointer_name=$2
> +	local child_path=$3
> +
> +	local parent_ppath="$parent_path/$parent_pointer_name"
> +
> +	# Verify parent exists
> +	if [ ! -d $SCRATCH_MNT/$parent_path ]; then
> +		_fail "$SCRATCH_MNT/$parent_path not found"
> +	else
> +		echo "*** $parent_path OK"
> +	fi
> +
> +	# Verify child exists
> +	if [ ! -f $SCRATCH_MNT/$child_path ]; then
> +		_fail "$SCRATCH_MNT/$child_path not found"
> +	else
> +		echo "*** $child_path OK"
> +	fi
> +
> +	# Verify the parent pointer name exists as a child of the parent
> +	if [ ! -f $SCRATCH_MNT/$parent_ppath ]; then
> +		_fail "$SCRATCH_MNT/$parent_ppath not found"
> +	else
> +		echo "*** $parent_ppath OK"
> +	fi
> +
> +	# Get the inodes of both parent and child
> +	pino="$(stat -c '%i' $SCRATCH_MNT/$parent_path)"
> +	cino="$(stat -c '%i' $SCRATCH_MNT/$child_path)"
> +
> +	# Get all the parent pointers of the child
> +	parents=($($XFS_IO_PROG -x -c \
> +	 "parent -f -i $pino -n $parent_pointer_name" $SCRATCH_MNT/$child_path))
> +	if [[ $? != 0 ]]; then
> +		 _fail "No parent pointers found for $child_path"
> +	fi
> +
> +	# Parse parent pointer output.
> +	# This sets PPINO PPGEN PPNAME PPNAME_LEN
> +	_parse_parent_pointer $parents $pino $parent_pointer_name
> +
> +	# If we didnt find one, bail out
> +	if [ $? -ne 0 ]; then
> +		_fail "No parent pointer record found for $parent_path"\
> +			"in $child_path"
> +	fi
> +
> +	# Verify the inode generated by the parent pointer name is
> +	# the same as the child inode
> +	pppino="$(stat -c '%i' $SCRATCH_MNT/$parent_ppath)"
> +	if [ $cino -ne $pppino ]
> +	then
> +		_fail "Bad parent pointer name value for $child_path."\
> +			"$SCRATCH_MNT/$parent_ppath belongs to inode $PPPINO,"\
> +			"but should be $cino"
> +	fi
> +
> +	echo "*** Verified parent pointer:"\
> +			"name:$PPNAME, namelen:$PPNAME_LEN"
> +	echo "*** Parent pointer OK for child $child_path"
> +}
> +
> +#
> +# _verify_parent parent_pointer_name pino child_path

_verify_no_parent

> +#
> +# Verify that the given child path contains no parent pointer entry
> +# for the given inode and file name
> +#
> +_verify_no_parent()
> +{
> +	local parent_pname=$1
> +	local pino=$2
> +	local child_path=$3
> +
> +	# Verify child exists
> +	if [ ! -f $SCRATCH_MNT/$child_path ]; then
> +		_fail "$SCRATCH_MNT/$child_path not found"
> +	else
> +		echo "*** $child_path OK"
> +	fi
> +
> +	# Get all the parent pointers of the child
> +	local parents=($($XFS_IO_PROG -x -c \
> +	 "parent -f -i $pino -n $parent_pname" $SCRATCH_MNT/$child_path))
> +	if [[ $? != 0 ]]; then
> +		return 0
> +	fi
> +
> +	# Parse parent pointer output.
> +	# This sets PPINO PPGEN PPNAME PPNAME_LEN
> +	_parse_parent_pointer $parents $pino $parent_pname
> +
> +	# If we didnt find one, return sucess
> +	if [ $? -ne 0 ]; then
> +		return 0
> +	fi
> +
> +	_fail "Parent pointer entry found where none should:"\
> +			"inode:$PPINO, gen:$PPGEN,"
> +			"name:$PPNAME, namelen:$PPNAME_LEN"
> +}
> diff --git a/common/rc b/common/rc
> index d1f3d56b..9fc0a785 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -2539,6 +2539,9 @@ _require_xfs_io_command()
>  		echo $testio | grep -q "invalid option" && \
>  			_notrun "xfs_io $command support is missing"
>  		;;
> +	"parent")
> +		testio=`$XFS_IO_PROG -x -c "parent" $TEST_DIR 2>&1`
> +		;;
>  	"pwrite")
>  		# -N (RWF_NOWAIT) only works with direct vectored I/O writes
>  		local pwrite_opts=" "
> diff --git a/common/xfs b/common/xfs
> index 170dd621..7233a2db 100644
> --- a/common/xfs
> +++ b/common/xfs
> @@ -1399,3 +1399,15 @@ _xfs_filter_mkfs()
>  		print STDOUT "realtime =RDEV extsz=XXX blocks=XXX, rtextents=XXX\n";
>  	}'
>  }
> +
> +# this test requires the xfs parent pointers feature
> +#
> +_require_xfs_parent()
> +{
> +	_scratch_mkfs_xfs_supported -n parent > /dev/null 2>&1 \
> +		|| _notrun "mkfs.xfs does not support parent pointers"
> +	_scratch_mkfs_xfs -n parent > /dev/null 2>&1
> +	_try_scratch_mount >/dev/null 2>&1 \
> +		|| _notrun "kernel does not support parent pointers"
> +	_scratch_unmount
> +}
> -- 
> 2.25.1
> 

