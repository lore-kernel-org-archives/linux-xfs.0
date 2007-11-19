Return-Path: <xfs-bounce@oss.sgi.com>
Received: with ECARTIS (v1.0.0; list xfs); Sun, 18 Nov 2007 19:50:08 -0800 (PST)
Received: from larry.melbourne.sgi.com (larry.melbourne.sgi.com [134.14.52.130])
	by oss.sgi.com (8.12.11.20060308/8.12.10/SuSE Linux 0.7) with SMTP id lAJ3o1m2003768
	for <xfs@oss.sgi.com>; Sun, 18 Nov 2007 19:50:02 -0800
Message-ID: <47410796.6090403@sgi.com>
Date: Mon, 19 Nov 2007 14:48:38 +1100
From: Lachlan McIlroy <lachlan@sgi.com>
Reply-To: lachlan@sgi.com
MIME-Version: 1.0
Subject: Re: REVIEW: xfs_reno #2
References: <op.tznnweh23jf8g2@pc-bnaujok.melbourne.sgi.com>
In-Reply-To: <op.tznnweh23jf8g2@pc-bnaujok.melbourne.sgi.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: xfs-bounce@oss.sgi.com
Errors-to: xfs-bounce@oss.sgi.com
List-Id: xfs
To: Barry Naujok <bnaujok@sgi.com>
Cc: "xfs@oss.sgi.com" <xfs@oss.sgi.com>, xfs-dev <xfs-dev@sgi.com>


+#define NH_BUCKETS	65536
+#define NH_HASH(ino)	(nodehash + ((ino) % NH_BUCKETS))
Hashing addresses by a power of two often results in an uneven
distribution over the hashtable.  Have you verified your hashing
algorithm?

+static nodelist_t *
+init_nodehash(void)
+{
+	int		i;
+
+	nodehash = calloc(NH_BUCKETS, sizeof(nodelist_t));
+	if (nodehash == NULL) {
+		err_nomem();
+		return NULL;
+	}
+
+	for (i = 0; i < NH_BUCKETS; i++) {
+		nodehash[i].nodes = NULL;
+		nodehash[i].lastnode = 0;
+		nodehash[i].listlen = 0;
+	}
No need to do this, calloc() zeroed the memory.

+
+	return nodehash;
+}


+static nlink_t
+add_path(
+	bignode_t	*node,
+	const char	*path)
+{
+	node->paths = realloc(node->paths,
+			      sizeof(char *) * (node->numpaths + 1));
Lots of little allocations here, realloc()'ing for space for one more
pointer is inefficient.  Can we alloc a chunk of pointers?

Just how many path pointers do we typically need?  Can we add an array
of initial pointers into bignode_t and when we exceed that start
allocating more chunks here?

+	if (node->paths == NULL) {
+		err_nomem();
+		exit(1);
+	}
+
+	node->paths[node->numpaths] = strdup(path);
More little allocations.  Can we preallocate a chunk of memory and
strcpy() the paths into it?  The array of path pointers would then
be indexes into the memory.

+	if (node->paths[node->numpaths] == NULL) {
+		err_nomem();
+		exit(1);
+	}
+
+	node->numpaths++;
+	if (node->numpaths > highest_numpaths)
+		highest_numpaths = node->numpaths;
+
+	return node->numpaths;
+}


+static bignode_t *
+add_node(
+	nodelist_t	*list,
+	xfs_ino_t	ino,
+	int		ftw_flags,
+	const char	*path)
+{
+	bignode_t	*node;
+
+	if (list->lastnode >= list->listlen) {
+		list->listlen += 500;
+		list->nodes = realloc(list->nodes,
+					sizeof(bignode_t) * list->listlen);
Can we avoid the realloc()?  (realloc() may need to copy the data
to a new location if it cannot extend the current allocation.)
For example each chunk of 500 nodes could end in a pointer to
the next chunk.

+		if (list->nodes == NULL) {
+			err_nomem();
+			return NULL;
+		}
+	}


+static bignode_t *
+find_node(
+	xfs_ino_t	ino)
+{
+	int		i;
+	nodelist_t	*nodelist;
+	bignode_t	*nodes;
+
+	nodelist = NH_HASH(ino);
+	nodes = nodelist->nodes;
+
+	for(i = 0; i < nodelist->lastnode; i++) {
+		if (nodes[i].ino == ino) {
By any chance do we read inodes in ascending order?  Or can they
be in random order?

If they are in ascending order then we could binary search here.
If not, and we call find_node() a lot, then it might be worth
sorting each list of nodes.

+			return &nodes[i];
+		}
+	}
+
+	return NULL;
+}


+		bignode_t	*nodes = nodehash[i].nodes;
+		for (j = 0; j < nodehash[i].lastnode; j++, nodes++)
+			dump_node("nodehash", nodes);
You have this code in various places.  You may be able to save a
few cycles by dropping the loop counter.  Note I have invented
listcount to be the actual number of nodes in the list.

	bignode_t	*nodes = nodehash[i].nodes;
	bignode_t	*lastnode = nodes + nodehash[i].listcount;
	for (; nodes < lastnode; nodes++)
		dump_node("nodehash", nodes);


+static int
+clone_attribs(
+	char		*source,
+	char		*target)
+{
+	char		list_buf[ATTRBUFSIZE];
May not be an issue putting 1k on stack here but could be a global
allocated on startup.

+	char		*attr_buf;
+	int		rval;
+
+	attr_buf = malloc(ATTR_MAX_VALUELEN * 2);
Could do this allocation on startup too - one less failure case to
worry about.

+	if (attr_buf == NULL) {
+		err_nomem();
+		return -1;
+	}
+	rval = attr_clone_copy(source, target, list_buf, attr_buf,
+			ATTR_MAX_VALUELEN * 2, 0);
+	if (rval == 0)
+		rval = attr_clone_copy(source, target, list_buf, attr_buf,
+				ATTR_MAX_VALUELEN * 2, ATTR_ROOT);
+	if (rval == 0)
+		rval = attr_clone_copy(source, target, list_buf, attr_buf,
+				ATTR_MAX_VALUELEN * 2, ATTR_SECURE);
+	free(attr_buf);
+	return rval;
+}


+	SET_PHASE(DIR_PHASE_7);
+
+	/* rename cur_target src */
+	rval = rename(cur_target, srcname);
+	if (rval != 0) {
+		/*
+		 * we can't abort since the src dir is now gone.
+		 * let the admin clean this one up
+		 */
+		err_message(_("unable to rename directory: %s to %s"),
+				cur_target, srcname);
+	}
+	goto quit;
+
+ quit_undo:
+	if (move_dirents(cur_target, srcname, &move_count) != 0) {
+		/* oh, dear lord... let the admin clean this one up */
+		err_message(_("unable to move directory contents back: %s to %s"),
+				cur_target, srcname);
+		goto quit;
+	}
Can we avoid these 'leave it to the admin to clean up' problems?
Could we rename the source directory to a temporary name, rename the
target to the source name and if all that works, remove the temporary
source otherwise remove the target and rename the source back again?
Not sure if that actually buys us anything since we're back to square
one if we can't rename the temporary source back again.


+static void
+update_recoverfile(void)
+{
+	static const char null_file[] = "0\n0\n0\n\ntarget: \ntemp: \nend\n";
+	static size_t	buf_size = 0;
+	static char	*buf = NULL;
+	int 		i, len;
+
+	if (recover_fd <= 0)
+		return;
+
+	if (cur_node == NULL || cur_phase == 0) {
+		/* inbetween processing or still scanning */
+		lseek(recover_fd, 0, SEEK_SET);
+		write(recover_fd, null_file, sizeof(null_file));
+		return;
+	}
+
+	ASSERT(highest_numpaths > 0);
+	if (buf == NULL) {
+		buf_size = (highest_numpaths + 3) * PATH_MAX;
+		buf = malloc(buf_size);
+		if (buf == NULL) {
+			err_nomem();
+			exit(1);
+		}
+	}
Should you check if highest_numpaths has increased and realloc the
buffer?  Or will we have finished the scan by the time we get here?

+
+	len = sprintf(buf, "%d\n%llu\n%d\n", cur_phase,
+			(long long)cur_node->ino, cur_node->ftw_flags);
+
+	for (i = 0; i < cur_node->numpaths; i++)
+		len += sprintf(buf + len, "%s\n", cur_node->paths[i]);
+
+	len += sprintf(buf + len, "target: %s\ntemp: %s\nend\n",
+			cur_target, cur_temp);
+
+	ASSERT(len < buf_size);
Can we use snprintf() instead?

+
+	lseek(recover_fd, 0, SEEK_SET);
+	ftruncate(recover_fd, 0);
+	write(recover_fd, buf, len);
+}

What's the test plan for xfs_reno?

Barry Naujok wrote:
> A couple changes from the first xfs_reno:
> 
>  - Major one is that symlinks are now supported, but only
>    owner, group and extended attributes are copied for them
>    (not times or inode attributes).
> 
>  - Man page!
> 
> 
> To make this better, ideally we need some form of
> "swap inodes" function in the kernel, where the entire
> contents of the inode themselves are swapped. This form
> can handle any inode and without any of the dir/file/attr/etc
> copy/swap mechanisms we have in xfs_reno.
> 
> Barry.
