Return-Path: <linux-xfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58284 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753583AbdC2QkS (ORCPT <rfc822;linux-xfs@vger.kernel.org>);
        Wed, 29 Mar 2017 12:40:18 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <8127.1490802589@warthog.procyon.org.uk>
References: <8127.1490802589@warthog.procyon.org.uk> <3791d155-b448-5257-d8b9-8a6f20e12180@sandeen.net> <7a090a8e-7204-1b9b-8b31-e7a061b39f87@sandeen.net>
Subject: Re: [PATCH] xfs_io: changes to statx interface [ver #3]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <9333.1490805615.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Wed, 29 Mar 2017 17:40:15 +0100
Message-ID: <9334.1490805615@warthog.procyon.org.uk>
Sender: linux-xfs-owner@vger.kernel.org
List-ID: <linux-xfs.vger.kernel.org>
List-Id: xfs
To: Eric Sandeen <sandeen@sandeen.net>
Cc: dhowells@redhat.com, linux-xfs <linux-xfs@vger.kernel.org>, Andreas Dilger <adilger@dilger.ca>, Christoph Hellwig <hch@infradead.org>, fsdevel <linux-fsdevel@vger.kernel.org>

David Howells <dhowells@redhat.com> wrote:

> Here's my third attempt at changing Eric's statx patch.  I've got rid of the
> compare option to statx and added a raw output option to stat.  They're still
> not directly comparable since the stat output lacks some fields, but it will
> hopefully be possible to load them into associative arrays in bash and compare
> them that way.

Kind of like this:

function cmpstat () {
    file=$1
    declare -A st stx

    # Read the stat output
    coproc { xfs_io -c "open -P $file" -c "stat -r" | sed -e s/://; }
    while read tag val
    do
	st[$tag]=$val
    done <&${COPROC[0]}
    wait || exit $?

    # Read the statx output
    coproc { xfs_io -c "open -P $file" -c "statx" | sed -e s/://; }
    while read tag val
    do
	stx[$tag]=$val
    done <&${COPROC[0]}
    wait || exit $?

    # Compare them
    for key in ${!stx[*]}
    do
	if [ "${stx[$key]}" != "${st[$key]}" ]
	then
	    case $key in
		stat.mask|stat.attributes|stat.btime.tv_*)
		    # Not supported in stat
		    ;;
		*)
		    echo differ $key "${stx[$key]}" != "${st[$key]}"
		    ;;
	    esac
	fi
    done
}

cmpstat /
